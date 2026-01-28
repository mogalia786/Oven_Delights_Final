Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class OpeningBalancesForm
    Inherits Form

    Private ReadOnly _connString As String
    Private dgvBalances As DataGridView
    Private cboAccount As ComboBox
    Private txtDebit As TextBox
    Private txtCredit As TextBox
    Private dtpDate As DateTimePicker
    Private txtDescription As TextBox
    Private btnAdd As Button
    Private btnSave As Button
    Private btnDelete As Button
    Private lblTotal As Label

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        Me.Text = "Opening Balances"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)
        
        LoadAccounts()
        LoadOpeningBalances()
    End Sub

    Private Sub InitializeComponent()
        Dim pnlTop As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 60,
            .BackColor = Color.FromArgb(52, 73, 94)
        }

        Dim lblTitle As New Label With {
            .Text = "Opening Balances",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 15),
            .AutoSize = True
        }
        pnlTop.Controls.Add(lblTitle)

        Dim pnlEntry As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = Color.White,
            .Padding = New Padding(20)
        }

        Dim lblAccount As New Label With {.Text = "Account:", .Location = New Point(20, 15), .Width = 70}
        cboAccount = New ComboBox With {
            .Location = New Point(100, 12),
            .Width = 400,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }

        Dim lblDate As New Label With {.Text = "Date:", .Location = New Point(520, 15), .Width = 50}
        dtpDate = New DateTimePicker With {
            .Location = New Point(580, 12),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = New Date(DateTime.Now.Year, 1, 1)
        }

        Dim lblDebit As New Label With {.Text = "Debit:", .Location = New Point(20, 55), .Width = 70}
        txtDebit = New TextBox With {
            .Location = New Point(100, 52),
            .Width = 150,
            .Text = "0.00"
        }
        AddHandler txtDebit.Enter, Sub() If txtDebit.Text = "0.00" Then txtDebit.Clear()
        AddHandler txtDebit.Leave, Sub() If String.IsNullOrWhiteSpace(txtDebit.Text) Then txtDebit.Text = "0.00"

        Dim lblCredit As New Label With {.Text = "Credit:", .Location = New Point(270, 55), .Width = 70}
        txtCredit = New TextBox With {
            .Location = New Point(350, 52),
            .Width = 150,
            .Text = "0.00"
        }
        AddHandler txtCredit.Enter, Sub() If txtCredit.Text = "0.00" Then txtCredit.Clear()
        AddHandler txtCredit.Leave, Sub() If String.IsNullOrWhiteSpace(txtCredit.Text) Then txtCredit.Text = "0.00"

        Dim lblDesc As New Label With {.Text = "Description:", .Location = New Point(520, 55), .Width = 80}
        txtDescription = New TextBox With {
            .Location = New Point(610, 52),
            .Width = 300,
            .Text = "Opening Balance"
        }

        btnAdd = New Button With {
            .Text = "Add",
            .Location = New Point(930, 50),
            .Size = New Size(100, 30),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        btnAdd.FlatAppearance.BorderSize = 0
        AddHandler btnAdd.Click, AddressOf BtnAdd_Click

        pnlEntry.Controls.AddRange({lblAccount, cboAccount, lblDate, dtpDate, lblDebit, txtDebit, lblCredit, txtCredit, lblDesc, txtDescription, btnAdd})

        dgvBalances = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .ReadOnly = False,
            .AllowUserToAddRows = False,
            .BackgroundColor = Color.White,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect
        }

        Dim pnlBottom As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 60,
            .BackColor = Color.FromArgb(240, 240, 245),
            .Padding = New Padding(20)
        }

        lblTotal = New Label With {
            .Text = "Total Debits: R 0.00 | Total Credits: R 0.00 | Difference: R 0.00",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(20, 15),
            .AutoSize = True
        }

        btnSave = New Button With {
            .Text = "Save All",
            .Location = New Point(900, 10),
            .Size = New Size(120, 40),
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf BtnSave_Click

        btnDelete = New Button With {
            .Text = "Delete",
            .Location = New Point(1040, 10),
            .Size = New Size(100, 40),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        btnDelete.FlatAppearance.BorderSize = 0
        AddHandler btnDelete.Click, AddressOf BtnDelete_Click

        pnlBottom.Controls.AddRange({lblTotal, btnSave, btnDelete})

        Me.Controls.AddRange({dgvBalances, pnlBottom, pnlEntry, pnlTop})
    End Sub

    Private Sub LoadAccounts()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT AccountID, AccountCode + ' - ' + AccountName AS DisplayName FROM ChartOfAccounts WHERE IsActive = 1 ORDER BY AccountCode"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(reader)
                        cboAccount.DisplayMember = "DisplayName"
                        cboAccount.ValueMember = "AccountID"
                        cboAccount.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadOpeningBalances()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT ob.OpeningBalanceID, coa.AccountCode, coa.AccountName, ob.FiscalYear, ob.DebitAmount, ob.CreditAmount, ob.Description " &
                         "FROM OpeningBalances ob " &
                         "INNER JOIN ChartOfAccounts coa ON ob.AccountID = coa.AccountID " &
                         "ORDER BY coa.AccountCode"
                
                Using adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvBalances.DataSource = dt
                    
                    If dgvBalances.Columns.Count > 0 Then
                        dgvBalances.Columns("OpeningBalanceID").Visible = False
                        dgvBalances.Columns("AccountCode").HeaderText = "Account Code"
                        dgvBalances.Columns("AccountCode").Width = 120
                        dgvBalances.Columns("AccountName").HeaderText = "Account Name"
                        dgvBalances.Columns("FiscalYear").HeaderText = "Year"
                        dgvBalances.Columns("FiscalYear").Width = 80
                        dgvBalances.Columns("DebitAmount").HeaderText = "Debit"
                        dgvBalances.Columns("DebitAmount").DefaultCellStyle.Format = "N2"
                        dgvBalances.Columns("DebitAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvBalances.Columns("CreditAmount").HeaderText = "Credit"
                        dgvBalances.Columns("CreditAmount").DefaultCellStyle.Format = "N2"
                        dgvBalances.Columns("CreditAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    
                    UpdateTotals()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading opening balances: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnAdd_Click(sender As Object, e As EventArgs)
        If cboAccount.SelectedValue Is Nothing Then
            MessageBox.Show("Please select an account", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim debit As Decimal = 0
        Dim credit As Decimal = 0

        If Not Decimal.TryParse(txtDebit.Text, debit) Then debit = 0
        If Not Decimal.TryParse(txtCredit.Text, credit) Then credit = 0

        If debit = 0 AndAlso credit = 0 Then
            MessageBox.Show("Please enter either a debit or credit amount", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If debit > 0 AndAlso credit > 0 Then
            MessageBox.Show("Please enter only debit OR credit, not both", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "INSERT INTO OpeningBalances (AccountID, FiscalYear, DebitAmount, CreditAmount, Description, ImportedBy) " &
                         "VALUES (@AccountID, @FiscalYear, @DebitAmount, @CreditAmount, @Description, @ImportedBy)"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@AccountID", cboAccount.SelectedValue)
                    cmd.Parameters.AddWithValue("@FiscalYear", dtpDate.Value.Year)
                    cmd.Parameters.AddWithValue("@DebitAmount", debit)
                    cmd.Parameters.AddWithValue("@CreditAmount", credit)
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text)
                    cmd.Parameters.AddWithValue("@ImportedBy", If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.Username, "System"))
                    
                    cmd.ExecuteNonQuery()
                    MessageBox.Show("Opening balance added successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    txtDebit.Text = "0.00"
                    txtCredit.Text = "0.00"
                    txtDescription.Text = "Opening Balance"
                    
                    LoadOpeningBalances()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error adding opening balance: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Opening balances saved. Click 'Post to GL' to create journal entries.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub BtnDelete_Click(sender As Object, e As EventArgs)
        If dgvBalances.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a row to delete", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If MessageBox.Show("Are you sure you want to delete this opening balance?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Try
                Dim obID = CInt(dgvBalances.SelectedRows(0).Cells("OpeningBalanceID").Value)
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "DELETE FROM OpeningBalances WHERE OpeningBalanceID = @ID"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@ID", obID)
                        cmd.ExecuteNonQuery()
                        MessageBox.Show("Opening balance deleted", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadOpeningBalances()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error deleting opening balance: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub UpdateTotals()
        If dgvBalances.DataSource Is Nothing Then Return
        
        Dim dt = CType(dgvBalances.DataSource, DataTable)
        If dt.Rows.Count = 0 Then
            lblTotal.Text = "Total Debits: R 0.00 | Total Credits: R 0.00 | Difference: R 0.00"
            Return
        End If
        
        Dim totalDebit = dt.AsEnumerable().Sum(Function(r) CDec(r("DebitAmount")))
        Dim totalCredit = dt.AsEnumerable().Sum(Function(r) CDec(r("CreditAmount")))
        Dim difference = totalDebit - totalCredit
        
        lblTotal.Text = $"Total Debits: R {totalDebit:N2} | Total Credits: R {totalCredit:N2} | Difference: R {difference:N2}"
        lblTotal.ForeColor = If(Math.Abs(difference) < 0.01, Color.FromArgb(39, 174, 96), Color.FromArgb(231, 76, 60))
    End Sub
End Class
