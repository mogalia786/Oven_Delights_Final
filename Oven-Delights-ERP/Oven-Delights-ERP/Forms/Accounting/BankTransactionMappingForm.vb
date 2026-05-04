Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class BankTransactionMappingForm
    Inherits Form

    Private ReadOnly _connectionString As String
    Private tabControl As TabControl
    Private dgvRules As DataGridView
    Private dgvPrefixes As DataGridView

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Bank Transaction Mapping Configuration"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        ' Main panel
        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Header
        Dim lblTitle As New Label With {
            .Text = "Bank Transaction Mapping Configuration",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .Location = New Point(20, 20),
            .Size = New Size(600, 35),
            .ForeColor = Color.FromArgb(41, 128, 185)
        }

        Dim lblSubtitle As New Label With {
            .Text = "Configure how bank transactions are automatically mapped to GL accounts and suppliers/customers",
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(20, 60),
            .Size = New Size(800, 25),
            .ForeColor = Color.FromArgb(127, 140, 141)
        }

        ' Tab Control
        tabControl = New TabControl With {
            .Location = New Point(20, 100),
            .Size = New Size(1140, 520),
            .Font = New Font("Segoe UI", 10)
        }

        ' Tab 1: Mapping Rules
        Dim tabRules As New TabPage("Mapping Rules")
        CreateRulesTab(tabRules)
        tabControl.TabPages.Add(tabRules)

        ' Tab 2: Entity Prefixes (Supplier/Customer Lookup)
        Dim tabPrefixes As New TabPage("Supplier/Customer Prefixes")
        CreatePrefixesTab(tabPrefixes)
        tabControl.TabPages.Add(tabPrefixes)

        ' Close button
        Dim btnClose As New Button With {
            .Text = "Close",
            .Location = New Point(1060, 630),
            .Size = New Size(100, 35),
            .BackColor = Color.FromArgb(149, 165, 166),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnClose.Click, Sub() Me.Close()

        pnlMain.Controls.AddRange({lblTitle, lblSubtitle, tabControl, btnClose})
        Me.Controls.Add(pnlMain)

        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub CreateRulesTab(tab As TabPage)
        ' Toolbar
        Dim pnlToolbar As New Panel With {.Dock = DockStyle.Top, .Height = 50, .Padding = New Padding(10)}

        Dim btnAddRule As New Button With {
            .Text = "+ Add Rule",
            .Location = New Point(10, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnAddRule.Click, AddressOf BtnAddRule_Click

        Dim btnEditRule As New Button With {
            .Text = "Edit Rule",
            .Location = New Point(140, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnEditRule.Click, AddressOf BtnEditRule_Click

        Dim btnDeleteRule As New Button With {
            .Text = "Delete Rule",
            .Location = New Point(270, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnDeleteRule.Click, AddressOf BtnDeleteRule_Click

        Dim btnRefreshRules As New Button With {
            .Text = "Refresh",
            .Location = New Point(400, 10),
            .Size = New Size(100, 30),
            .BackColor = Color.FromArgb(149, 165, 166),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnRefreshRules.Click, Sub() LoadMappingRules()

        pnlToolbar.Controls.AddRange({btnAddRule, btnEditRule, btnDeleteRule, btnRefreshRules})

        ' DataGridView for rules
        dgvRules = New DataGridView With {
            .Dock = DockStyle.Fill,
            .BackgroundColor = Color.White,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .RowHeadersVisible = False
        }

        tab.Controls.AddRange({pnlToolbar, dgvRules})
    End Sub

    Private Sub CreatePrefixesTab(tab As TabPage)
        ' Toolbar
        Dim pnlToolbar As New Panel With {.Dock = DockStyle.Top, .Height = 50, .Padding = New Padding(10)}

        Dim btnAddPrefix As New Button With {
            .Text = "+ Add Prefix",
            .Location = New Point(10, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnAddPrefix.Click, AddressOf BtnAddPrefix_Click

        Dim btnEditPrefix As New Button With {
            .Text = "Edit Prefix",
            .Location = New Point(140, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnEditPrefix.Click, AddressOf BtnEditPrefix_Click

        Dim btnDeletePrefix As New Button With {
            .Text = "Delete Prefix",
            .Location = New Point(270, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnDeletePrefix.Click, AddressOf BtnDeletePrefix_Click

        Dim btnRefreshPrefixes As New Button With {
            .Text = "Refresh",
            .Location = New Point(400, 10),
            .Size = New Size(100, 30),
            .BackColor = Color.FromArgb(149, 165, 166),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnRefreshPrefixes.Click, Sub() LoadEntityPrefixes()

        pnlToolbar.Controls.AddRange({btnAddPrefix, btnEditPrefix, btnDeletePrefix, btnRefreshPrefixes})

        ' DataGridView for prefixes
        dgvPrefixes = New DataGridView With {
            .Dock = DockStyle.Fill,
            .BackgroundColor = Color.White,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .RowHeadersVisible = False
        }

        tab.Controls.AddRange({pnlToolbar, dgvPrefixes})
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadMappingRules()
        LoadEntityPrefixes()
    End Sub

    Private Sub LoadMappingRules()
        Try
            If dgvRules Is Nothing Then
                Return
            End If
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT RuleID, RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, IsActive FROM BankTransactionMappingRules ORDER BY Priority"
                Using adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvRules.DataSource = dt
                    
                    ' Format columns after DataSource is set
                    FormatRulesGrid()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading mapping rules: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub FormatRulesGrid()
        Try
            If dgvRules.Columns.Count = 0 Then Return
            
            For Each col As DataGridViewColumn In dgvRules.Columns
                Select Case col.Name
                    Case "RuleID"
                        col.Visible = False
                    Case "RuleName"
                        col.HeaderText = "Rule Name"
                        col.Width = 200
                    Case "MatchType"
                        col.HeaderText = "Match Type"
                        col.Width = 100
                    Case "MatchValue"
                        col.HeaderText = "Match Value"
                        col.Width = 150
                    Case "TransactionType"
                        col.HeaderText = "Transaction Type"
                        col.Width = 120
                    Case "TargetLedger"
                        col.HeaderText = "Target Ledger"
                        col.Width = 120
                    Case "AccountCode"
                        col.HeaderText = "Account Code"
                        col.Width = 100
                    Case "Priority"
                        col.HeaderText = "Priority"
                        col.Width = 80
                    Case "IsActive"
                        col.HeaderText = "Active"
                        col.Width = 80
                End Select
            Next
        Catch ex As Exception
            ' Silently fail column formatting - not critical
        End Try
    End Sub

    Private Sub LoadEntityPrefixes()
        Try
            If dgvPrefixes Is Nothing Then
                Return
            End If
            
            If String.IsNullOrEmpty(_connectionString) Then
                MessageBox.Show("Connection string is not configured.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT PrefixID, Prefix, EntityType, EntityName, IsActive FROM BankTransactionEntityPrefixes ORDER BY Prefix"
                Using adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvPrefixes.DataSource = dt
                    
                    ' Format columns after DataSource is set
                    FormatPrefixesGrid()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading entity prefixes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub FormatPrefixesGrid()
        Try
            If dgvPrefixes.Columns.Count = 0 Then Return
            
            For Each col As DataGridViewColumn In dgvPrefixes.Columns
                Select Case col.Name
                    Case "PrefixID"
                        col.Visible = False
                    Case "Prefix"
                        col.HeaderText = "Prefix/Keyword"
                        col.Width = 250
                    Case "EntityType"
                        col.HeaderText = "Type"
                        col.Width = 100
                    Case "EntityName"
                        col.HeaderText = "Supplier/Customer Name"
                        col.Width = 300
                    Case "IsActive"
                        col.HeaderText = "Active"
                        col.Width = 80
                End Select
            Next
        Catch ex As Exception
            ' Silently fail column formatting - not critical
        End Try
    End Sub

    Private Sub BtnAddRule_Click(sender As Object, e As EventArgs)
        Using frm As New MappingRuleEditForm(Nothing)
            If frm.ShowDialog(Me) = DialogResult.OK Then
                LoadMappingRules()
            End If
        End Using
    End Sub

    Private Sub BtnEditRule_Click(sender As Object, e As EventArgs)
        If dgvRules.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a rule to edit", "Edit Rule", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        Dim ruleId = CInt(dgvRules.SelectedRows(0).Cells("RuleID").Value)
        Using frm As New MappingRuleEditForm(ruleId)
            If frm.ShowDialog(Me) = DialogResult.OK Then
                LoadMappingRules()
            End If
        End Using
    End Sub

    Private Sub BtnDeleteRule_Click(sender As Object, e As EventArgs)
        If dgvRules.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a rule to delete", "Delete Rule", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        If MessageBox.Show("Are you sure you want to delete this mapping rule?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.No Then
            Return
        End If

        Try
            Dim ruleId = CInt(dgvRules.SelectedRows(0).Cells("RuleID").Value)
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("DELETE FROM BankTransactionMappingRules WHERE RuleID = @RuleID", conn)
                    cmd.Parameters.AddWithValue("@RuleID", ruleId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadMappingRules()
            MessageBox.Show("Rule deleted successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error deleting rule: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnAddPrefix_Click(sender As Object, e As EventArgs)
        Using frm As New EntityPrefixEditForm(Nothing)
            If frm.ShowDialog(Me) = DialogResult.OK Then
                LoadEntityPrefixes()
            End If
        End Using
    End Sub

    Private Sub BtnEditPrefix_Click(sender As Object, e As EventArgs)
        If dgvPrefixes.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a prefix to edit", "Edit Prefix", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        Dim prefixId = CInt(dgvPrefixes.SelectedRows(0).Cells("PrefixID").Value)
        Using frm As New EntityPrefixEditForm(prefixId)
            If frm.ShowDialog(Me) = DialogResult.OK Then
                LoadEntityPrefixes()
            End If
        End Using
    End Sub

    Private Sub BtnDeletePrefix_Click(sender As Object, e As EventArgs)
        If dgvPrefixes.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a prefix to delete", "Delete Prefix", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        If MessageBox.Show("Are you sure you want to delete this prefix mapping?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.No Then
            Return
        End If

        Try
            Dim prefixId = CInt(dgvPrefixes.SelectedRows(0).Cells("PrefixID").Value)
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("DELETE FROM BankTransactionEntityPrefixes WHERE PrefixID = @PrefixID", conn)
                    cmd.Parameters.AddWithValue("@PrefixID", prefixId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadEntityPrefixes()
            MessageBox.Show("Prefix deleted successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error deleting prefix: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class

' =============================================
' Mapping Rule Edit Form
' =============================================
Public Class MappingRuleEditForm
    Inherits Form

    Private ReadOnly _connectionString As String
    Private ReadOnly _ruleId As Integer?
    Private txtRuleName As TextBox
    Private cboMatchType As ComboBox
    Private txtMatchValue As TextBox
    Private cboTransactionType As ComboBox
    Private cboTargetLedger As ComboBox
    Private txtAccountCode As TextBox
    Private numPriority As NumericUpDown
    Private chkActive As CheckBox
    Private txtNotes As TextBox

    Public Sub New(ruleId As Integer?)
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _ruleId = ruleId
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = If(_ruleId.HasValue, "Edit Mapping Rule", "Add Mapping Rule")
        Me.Size = New Size(600, 550)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False

        Dim y = 20

        ' Rule Name
        Dim lblName As New Label With {.Text = "Rule Name:", .Location = New Point(20, y), .Width = 120}
        txtRuleName = New TextBox With {.Location = New Point(150, y), .Width = 400}
        Me.Controls.AddRange({lblName, txtRuleName})
        y += 35

        ' Match Type
        Dim lblMatchType As New Label With {.Text = "Match Type:", .Location = New Point(20, y), .Width = 120}
        cboMatchType = New ComboBox With {.Location = New Point(150, y), .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        cboMatchType.Items.AddRange({"Prefix", "Contains", "Exact", "Suffix"})
        Me.Controls.AddRange({lblMatchType, cboMatchType})
        y += 35

        ' Match Value
        Dim lblMatchValue As New Label With {.Text = "Match Value:", .Location = New Point(20, y), .Width = 120}
        txtMatchValue = New TextBox With {.Location = New Point(150, y), .Width = 400}
        Me.Controls.AddRange({lblMatchValue, txtMatchValue})
        y += 35

        ' Transaction Type
        Dim lblTransType As New Label With {.Text = "Transaction Type:", .Location = New Point(20, y), .Width = 120}
        cboTransactionType = New ComboBox With {.Location = New Point(150, y), .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        cboTransactionType.Items.AddRange({"Payment", "Receipt", "Transfer", "Fee"})
        Me.Controls.AddRange({lblTransType, cboTransactionType})
        y += 35

        ' Target Ledger
        Dim lblTargetLedger As New Label With {.Text = "Target Ledger:", .Location = New Point(20, y), .Width = 120}
        cboTargetLedger = New ComboBox With {.Location = New Point(150, y), .Width = 250, .DropDownStyle = ComboBoxStyle.DropDownList}
        cboTargetLedger.Items.AddRange({"AccountsPayable", "AccountsReceivable", "Bank", "BankFees", "InterBranch", "Other"})
        Me.Controls.AddRange({lblTargetLedger, cboTargetLedger})
        y += 35

        ' Account Code
        Dim lblAccountCode As New Label With {.Text = "Account Code:", .Location = New Point(20, y), .Width = 120}
        txtAccountCode = New TextBox With {.Location = New Point(150, y), .Width = 100}
        Me.Controls.AddRange({lblAccountCode, txtAccountCode})
        y += 35

        ' Priority
        Dim lblPriority As New Label With {.Text = "Priority:", .Location = New Point(20, y), .Width = 120}
        numPriority = New NumericUpDown With {.Location = New Point(150, y), .Width = 100, .Minimum = 1, .Maximum = 1000, .Value = 100}
        Me.Controls.AddRange({lblPriority, numPriority})
        y += 35

        ' Active
        chkActive = New CheckBox With {.Text = "Active", .Location = New Point(150, y), .Checked = True}
        Me.Controls.Add(chkActive)
        y += 35

        ' Notes
        Dim lblNotes As New Label With {.Text = "Notes:", .Location = New Point(20, y), .Width = 120}
        txtNotes = New TextBox With {.Location = New Point(150, y), .Width = 400, .Height = 80, .Multiline = True}
        Me.Controls.AddRange({lblNotes, txtNotes})
        y += 90

        ' Buttons
        Dim btnSave As New Button With {.Text = "Save", .Location = New Point(350, y), .Size = New Size(100, 35), .DialogResult = DialogResult.OK}
        Dim btnCancel As New Button With {.Text = "Cancel", .Location = New Point(460, y), .Size = New Size(100, 35), .DialogResult = DialogResult.Cancel}
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        Me.Controls.AddRange({btnSave, btnCancel})
        Me.AcceptButton = btnSave
        Me.CancelButton = btnCancel

        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        If _ruleId.HasValue Then
            LoadRule()
        End If
    End Sub

    Private Sub LoadRule()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, IsActive, Notes FROM BankTransactionMappingRules WHERE RuleID = @RuleID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@RuleID", _ruleId.Value)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtRuleName.Text = reader("RuleName").ToString()
                            cboMatchType.SelectedItem = reader("MatchType").ToString()
                            txtMatchValue.Text = reader("MatchValue").ToString()
                            cboTransactionType.SelectedItem = reader("TransactionType").ToString()
                            cboTargetLedger.SelectedItem = reader("TargetLedger").ToString()
                            txtAccountCode.Text = If(IsDBNull(reader("AccountCode")), "", reader("AccountCode").ToString())
                            numPriority.Value = CInt(reader("Priority"))
                            chkActive.Checked = CBool(reader("IsActive"))
                            txtNotes.Text = If(IsDBNull(reader("Notes")), "", reader("Notes").ToString())
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading rule: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtRuleName.Text) Then
            MessageBox.Show("Please enter a rule name", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        If cboMatchType.SelectedIndex = -1 Then
            MessageBox.Show("Please select a match type", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        If String.IsNullOrWhiteSpace(txtMatchValue.Text) Then
            MessageBox.Show("Please enter a match value", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql As String

                If _ruleId.HasValue Then
                    sql = "UPDATE BankTransactionMappingRules SET RuleName = @RuleName, MatchType = @MatchType, MatchValue = @MatchValue, TransactionType = @TransactionType, TargetLedger = @TargetLedger, AccountCode = @AccountCode, Priority = @Priority, IsActive = @IsActive, Notes = @Notes, ModifiedBy = @ModifiedBy, ModifiedDate = GETDATE() WHERE RuleID = @RuleID"
                Else
                    sql = "INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, IsActive, Notes, CreatedBy, CreatedDate) VALUES (@RuleName, @MatchType, @MatchValue, @TransactionType, @TargetLedger, @AccountCode, @Priority, @IsActive, @Notes, @ModifiedBy, GETDATE())"
                End If

                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@RuleName", txtRuleName.Text.Trim())
                    cmd.Parameters.AddWithValue("@MatchType", cboMatchType.SelectedItem.ToString())
                    cmd.Parameters.AddWithValue("@MatchValue", txtMatchValue.Text.Trim())
                    cmd.Parameters.AddWithValue("@TransactionType", If(cboTransactionType.SelectedIndex >= 0, cboTransactionType.SelectedItem.ToString(), DBNull.Value))
                    cmd.Parameters.AddWithValue("@TargetLedger", If(cboTargetLedger.SelectedIndex >= 0, cboTargetLedger.SelectedItem.ToString(), DBNull.Value))
                    cmd.Parameters.AddWithValue("@AccountCode", If(String.IsNullOrWhiteSpace(txtAccountCode.Text), DBNull.Value, txtAccountCode.Text.Trim()))
                    cmd.Parameters.AddWithValue("@Priority", numPriority.Value)
                    cmd.Parameters.AddWithValue("@IsActive", chkActive.Checked)
                    cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrWhiteSpace(txtNotes.Text), DBNull.Value, txtNotes.Text.Trim()))
                    cmd.Parameters.AddWithValue("@ModifiedBy", Environment.UserName)
                    If _ruleId.HasValue Then
                        cmd.Parameters.AddWithValue("@RuleID", _ruleId.Value)
                    End If
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            MessageBox.Show("Rule saved successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error saving rule: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.None
        End Try
    End Sub
End Class

' =============================================
' Entity Prefix Edit Form
' =============================================
Public Class EntityPrefixEditForm
    Inherits Form

    Private ReadOnly _connectionString As String
    Private ReadOnly _prefixId As Integer?
    Private txtPrefix As TextBox
    Private cboEntityType As ComboBox
    Private cboSupplier As ComboBox
    Private cboCustomer As ComboBox
    Private chkActive As CheckBox

    Public Sub New(prefixId As Integer?)
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _prefixId = prefixId
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = If(_prefixId.HasValue, "Edit Entity Prefix", "Add Entity Prefix")
        Me.Size = New Size(550, 350)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False

        Dim y = 20

        ' Prefix
        Dim lblPrefix As New Label With {.Text = "Prefix/Keyword:", .Location = New Point(20, y), .Width = 120}
        txtPrefix = New TextBox With {.Location = New Point(150, y), .Width = 350}
        Me.Controls.AddRange({lblPrefix, txtPrefix})
        y += 35

        ' Entity Type
        Dim lblEntityType As New Label With {.Text = "Entity Type:", .Location = New Point(20, y), .Width = 120}
        cboEntityType = New ComboBox With {.Location = New Point(150, y), .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        cboEntityType.Items.AddRange({"Supplier", "Customer"})
        AddHandler cboEntityType.SelectedIndexChanged, AddressOf EntityType_Changed
        Me.Controls.AddRange({lblEntityType, cboEntityType})
        y += 35

        ' Supplier
        Dim lblSupplier As New Label With {.Text = "Supplier:", .Location = New Point(20, y), .Width = 120}
        cboSupplier = New ComboBox With {.Location = New Point(150, y), .Width = 350, .DropDownStyle = ComboBoxStyle.DropDownList}
        Me.Controls.AddRange({lblSupplier, cboSupplier})
        y += 35

        ' Customer
        Dim lblCustomer As New Label With {.Text = "Customer:", .Location = New Point(20, y), .Width = 120}
        cboCustomer = New ComboBox With {.Location = New Point(150, y), .Width = 350, .DropDownStyle = ComboBoxStyle.DropDownList}
        Me.Controls.AddRange({lblCustomer, cboCustomer})
        y += 35

        ' Active
        chkActive = New CheckBox With {.Text = "Active", .Location = New Point(150, y), .Checked = True}
        Me.Controls.Add(chkActive)
        y += 50

        ' Buttons
        Dim btnSave As New Button With {.Text = "Save", .Location = New Point(300, y), .Size = New Size(100, 35), .DialogResult = DialogResult.OK}
        Dim btnCancel As New Button With {.Text = "Cancel", .Location = New Point(410, y), .Size = New Size(100, 35), .DialogResult = DialogResult.Cancel}
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        Me.Controls.AddRange({btnSave, btnCancel})
        Me.AcceptButton = btnSave
        Me.CancelButton = btnCancel

        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadSuppliers()
        LoadCustomers()
        If _prefixId.HasValue Then
            LoadPrefix()
        End If
    End Sub

    Private Sub LoadSuppliers()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT SupplierID, SupplierName FROM Suppliers WHERE IsActive = 1 ORDER BY SupplierName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        cboSupplier.Items.Clear()
                        cboSupplier.Items.Add(New With {.SupplierID = 0, .SupplierName = "-- Select Supplier --"})
                        While reader.Read()
                            cboSupplier.Items.Add(New With {.SupplierID = CInt(reader("SupplierID")), .SupplierName = reader("SupplierName").ToString()})
                        End While
                    End Using
                End Using
                cboSupplier.DisplayMember = "SupplierName"
                cboSupplier.ValueMember = "SupplierID"
                cboSupplier.SelectedIndex = 0
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadCustomers()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT CustomerID, CustomerName FROM Customers WHERE IsActive = 1 ORDER BY CustomerName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        cboCustomer.Items.Clear()
                        cboCustomer.Items.Add(New With {.CustomerID = 0, .CustomerName = "-- Select Customer --"})
                        While reader.Read()
                            cboCustomer.Items.Add(New With {.CustomerID = CInt(reader("CustomerID")), .CustomerName = reader("CustomerName").ToString()})
                        End While
                    End Using
                End Using
                cboCustomer.DisplayMember = "CustomerName"
                cboCustomer.ValueMember = "CustomerID"
                cboCustomer.SelectedIndex = 0
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading customers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadPrefix()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT Prefix, EntityType, SupplierID, CustomerID, IsActive FROM BankTransactionEntityPrefixes WHERE PrefixID = @PrefixID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@PrefixID", _prefixId.Value)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtPrefix.Text = reader("Prefix").ToString()
                            cboEntityType.SelectedItem = reader("EntityType").ToString()
                            
                            If Not IsDBNull(reader("SupplierID")) Then
                                Dim supplierId = CInt(reader("SupplierID"))
                                For Each item In cboSupplier.Items
                                    If item.SupplierID = supplierId Then
                                        cboSupplier.SelectedItem = item
                                        Exit For
                                    End If
                                Next
                            End If
                            
                            If Not IsDBNull(reader("CustomerID")) Then
                                Dim customerId = CInt(reader("CustomerID"))
                                For Each item In cboCustomer.Items
                                    If item.CustomerID = customerId Then
                                        cboCustomer.SelectedItem = item
                                        Exit For
                                    End If
                                Next
                            End If
                            
                            chkActive.Checked = CBool(reader("IsActive"))
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading prefix: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub EntityType_Changed(sender As Object, e As EventArgs)
        If cboEntityType.SelectedItem?.ToString() = "Supplier" Then
            cboSupplier.Enabled = True
            cboCustomer.Enabled = False
            cboCustomer.SelectedIndex = 0
        ElseIf cboEntityType.SelectedItem?.ToString() = "Customer" Then
            cboSupplier.Enabled = False
            cboCustomer.Enabled = True
            cboSupplier.SelectedIndex = 0
        End If
    End Sub

    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtPrefix.Text) Then
            MessageBox.Show("Please enter a prefix/keyword", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        If cboEntityType.SelectedIndex = -1 Then
            MessageBox.Show("Please select an entity type", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.DialogResult = DialogResult.None
            Return
        End If

        Dim supplierId As Integer? = Nothing
        Dim customerId As Integer? = Nothing
        Dim entityName As String = ""

        If cboEntityType.SelectedItem.ToString() = "Supplier" Then
            If cboSupplier.SelectedIndex <= 0 Then
                MessageBox.Show("Please select a supplier", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Me.DialogResult = DialogResult.None
                Return
            End If
            supplierId = cboSupplier.SelectedItem.SupplierID
            entityName = cboSupplier.SelectedItem.SupplierName
        Else
            If cboCustomer.SelectedIndex <= 0 Then
                MessageBox.Show("Please select a customer", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Me.DialogResult = DialogResult.None
                Return
            End If
            customerId = cboCustomer.SelectedItem.CustomerID
            entityName = cboCustomer.SelectedItem.CustomerName
        End If

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql As String

                If _prefixId.HasValue Then
                    sql = "UPDATE BankTransactionEntityPrefixes SET Prefix = @Prefix, EntityType = @EntityType, SupplierID = @SupplierID, CustomerID = @CustomerID, EntityName = @EntityName, IsActive = @IsActive WHERE PrefixID = @PrefixID"
                Else
                    sql = "INSERT INTO BankTransactionEntityPrefixes (Prefix, EntityType, SupplierID, CustomerID, EntityName, IsActive) VALUES (@Prefix, @EntityType, @SupplierID, @CustomerID, @EntityName, @IsActive)"
                End If

                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Prefix", txtPrefix.Text.Trim())
                    cmd.Parameters.AddWithValue("@EntityType", cboEntityType.SelectedItem.ToString())
                    cmd.Parameters.AddWithValue("@SupplierID", If(supplierId.HasValue, CObj(supplierId.Value), DBNull.Value))
                    cmd.Parameters.AddWithValue("@CustomerID", If(customerId.HasValue, CObj(customerId.Value), DBNull.Value))
                    cmd.Parameters.AddWithValue("@EntityName", entityName)
                    cmd.Parameters.AddWithValue("@IsActive", chkActive.Checked)
                    If _prefixId.HasValue Then
                        cmd.Parameters.AddWithValue("@PrefixID", _prefixId.Value)
                    End If
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            MessageBox.Show("Prefix saved successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error saving prefix: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.None
        End Try
    End Sub
End Class
