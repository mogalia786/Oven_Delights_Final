Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class ChartOfAccountsManagerForm
    Inherits Form

    Private ReadOnly _connectionString As String
    Private _accountsTable As DataTable

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Chart of Accounts Manager"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        ' Main panel
        Dim pnlMain As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20)
        }

        ' Title
        Dim lblTitle As New Label With {
            .Text = "Chart of Accounts",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .Dock = DockStyle.Top,
            .Height = 50,
            .TextAlign = ContentAlignment.MiddleLeft
        }

        ' Toolbar
        Dim pnlToolbar As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 50
        }

        Dim btnAdd As New Button With {
            .Text = "Add Account",
            .Location = New Point(0, 10),
            .Size = New Size(120, 35)
        }
        AddHandler btnAdd.Click, AddressOf BtnAdd_Click

        Dim btnEdit As New Button With {
            .Text = "Edit Account",
            .Location = New Point(130, 10),
            .Size = New Size(120, 35)
        }
        AddHandler btnEdit.Click, AddressOf BtnEdit_Click

        Dim btnRefresh As New Button With {
            .Text = "Refresh",
            .Location = New Point(260, 10),
            .Size = New Size(100, 35)
        }
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click

        pnlToolbar.Controls.AddRange({btnAdd, btnEdit, btnRefresh})

        ' DataGridView
        Dim dgvAccounts As New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .Name = "dgvAccounts"
        }

        pnlMain.Controls.Add(dgvAccounts)
        pnlMain.Controls.Add(pnlToolbar)
        pnlMain.Controls.Add(lblTitle)
        Me.Controls.Add(pnlMain)

        ' Load data
        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadAccounts()
    End Sub

    Private Sub LoadAccounts()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT AccountID, AccountCode, AccountName, AccountType, OpeningBalance, CurrentBalance, IsActive FROM ChartOfAccounts ORDER BY AccountCode"
                Using adapter As New SqlDataAdapter(sql, conn)
                    _accountsTable = New DataTable()
                    adapter.Fill(_accountsTable)

                    Dim dgv = CType(Me.Controls(0).Controls("dgvAccounts"), DataGridView)
                    dgv.DataSource = _accountsTable

                    ' Format columns
                    dgv.Columns("AccountID").Visible = False
                    dgv.Columns("AccountCode").HeaderText = "Code"
                    dgv.Columns("AccountCode").Width = 100
                    dgv.Columns("AccountName").HeaderText = "Account Name"
                    dgv.Columns("AccountType").HeaderText = "Type"
                    dgv.Columns("AccountType").Width = 120
                    dgv.Columns("OpeningBalance").HeaderText = "Opening Balance"
                    dgv.Columns("OpeningBalance").DefaultCellStyle.Format = "N2"
                    dgv.Columns("OpeningBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgv.Columns("CurrentBalance").HeaderText = "Current Balance"
                    dgv.Columns("CurrentBalance").DefaultCellStyle.Format = "N2"
                    dgv.Columns("CurrentBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgv.Columns("IsActive").HeaderText = "Active"
                    dgv.Columns("IsActive").Width = 80
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnAdd_Click(sender As Object, e As EventArgs)
        Using frm As New AccountEditForm(Nothing)
            If frm.ShowDialog(Me) = DialogResult.OK Then
                LoadAccounts()
            End If
        End Using
    End Sub

    Private Sub BtnEdit_Click(sender As Object, e As EventArgs)
        Dim dgv = CType(Me.Controls(0).Controls("dgvAccounts"), DataGridView)
        If dgv.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select an account to edit", "Edit Account", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        Dim accountId = CInt(dgv.SelectedRows(0).Cells("AccountID").Value)
        Using frm As New AccountEditForm(accountId)
            If frm.ShowDialog(Me) = DialogResult.OK Then
                LoadAccounts()
            End If
        End Using
    End Sub

    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadAccounts()
    End Sub
End Class

' =============================================
' Account Edit Form
' =============================================
Public Class AccountEditForm
    Inherits Form

    Private ReadOnly _connectionString As String
    Private ReadOnly _accountId As Integer?
    Private txtCode As TextBox
    Private txtName As TextBox
    Private cboType As ComboBox
    Private txtOpeningBalance As TextBox
    Private chkActive As CheckBox

    Public Sub New(accountId As Integer?)
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _accountId = accountId
    End Sub

    Private Sub InitializeComponent()
        Me.Text = If(_accountId.HasValue, "Edit Account", "Add Account")
        Me.Size = New Size(500, 400)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False

        Dim y = 20

        ' Account Code
        Dim lblCode As New Label With {.Text = "Account Code:", .Location = New Point(20, y), .Width = 120}
        txtCode = New TextBox With {.Location = New Point(150, y), .Width = 300}
        Me.Controls.AddRange({lblCode, txtCode})
        y += 40

        ' Account Name
        Dim lblName As New Label With {.Text = "Account Name:", .Location = New Point(20, y), .Width = 120}
        txtName = New TextBox With {.Location = New Point(150, y), .Width = 300}
        Me.Controls.AddRange({lblName, txtName})
        y += 40

        ' Account Type
        Dim lblType As New Label With {.Text = "Account Type:", .Location = New Point(20, y), .Width = 120}
        cboType = New ComboBox With {
            .Location = New Point(150, y),
            .Width = 300,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cboType.Items.AddRange({"Asset", "Liability", "Equity", "Revenue", "Cost of Sales", "Expense"})
        Me.Controls.AddRange({lblType, cboType})
        y += 40

        ' Opening Balance
        Dim lblOpening As New Label With {.Text = "Opening Balance:", .Location = New Point(20, y), .Width = 120}
        txtOpeningBalance = New TextBox With {.Location = New Point(150, y), .Width = 150, .Text = "0.00"}
        Me.Controls.AddRange({lblOpening, txtOpeningBalance})
        y += 40

        ' Active
        chkActive = New CheckBox With {.Text = "Active", .Location = New Point(150, y), .Checked = True}
        Me.Controls.Add(chkActive)
        y += 50

        ' Buttons
        Dim btnSave As New Button With {.Text = "Save", .Location = New Point(250, y), .Size = New Size(100, 35), .DialogResult = DialogResult.OK}
        Dim btnCancel As New Button With {.Text = "Cancel", .Location = New Point(360, y), .Size = New Size(100, 35), .DialogResult = DialogResult.Cancel}
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        Me.Controls.AddRange({btnSave, btnCancel})
        Me.AcceptButton = btnSave
        Me.CancelButton = btnCancel

        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        If _accountId.HasValue Then
            LoadAccount()
        End If
    End Sub

    Private Sub LoadAccount()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT AccountCode, AccountName, AccountType, OpeningBalance, IsActive FROM ChartOfAccounts WHERE AccountID = @AccountID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@AccountID", _accountId.Value)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtCode.Text = reader("AccountCode").ToString()
                            txtName.Text = reader("AccountName").ToString()
                            cboType.SelectedItem = reader("AccountType").ToString()
                            txtOpeningBalance.Text = CDec(reader("OpeningBalance")).ToString("N2")
                            chkActive.Checked = CBool(reader("IsActive"))
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading account: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtCode.Text) Then
            MessageBox.Show("Please enter an account code", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        If String.IsNullOrWhiteSpace(txtName.Text) Then
            MessageBox.Show("Please enter an account name", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        If cboType.SelectedIndex = -1 Then
            MessageBox.Show("Please select an account type", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        Try
            Dim openingBalance As Decimal
            If Not Decimal.TryParse(txtOpeningBalance.Text, openingBalance) Then
                MessageBox.Show("Please enter a valid opening balance", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Me.DialogResult = DialogResult.None
                Return
            End If

            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql As String

                If _accountId.HasValue Then
                    sql = "UPDATE ChartOfAccounts SET AccountCode = @Code, AccountName = @Name, AccountType = @Type, OpeningBalance = @Opening, IsActive = @Active WHERE AccountID = @AccountID"
                Else
                    sql = "INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, OpeningBalance, CurrentBalance, IsActive, CreatedBy, CreatedDate) VALUES (@Code, @Name, @Type, @Opening, @Opening, @Active, 'System', GETDATE())"
                End If

                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Code", txtCode.Text.Trim())
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim())
                    cmd.Parameters.AddWithValue("@Type", cboType.SelectedItem.ToString())
                    cmd.Parameters.AddWithValue("@Opening", openingBalance)
                    cmd.Parameters.AddWithValue("@Active", chkActive.Checked)
                    If _accountId.HasValue Then
                        cmd.Parameters.AddWithValue("@AccountID", _accountId.Value)
                    End If
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            MessageBox.Show("Account saved successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error saving account: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.None
        End Try
    End Sub
End Class
