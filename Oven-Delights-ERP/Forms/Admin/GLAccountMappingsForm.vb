' GLAccountMappingsForm.vb
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Public Class GLAccountMappingsForm
    Inherits Form

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private ReadOnly grid As New DataGridView() With {
        .Dock = DockStyle.Fill,
        .AutoGenerateColumns = False,
        .AllowUserToAddRows = True,
        .AllowUserToDeleteRows = True
    }
    Private ReadOnly btnSave As New Button() With {.Text = "Save", .Dock = DockStyle.Right, .Width = 120}

    Private mappings As DataTable
    Private accounts As DataTable

    Public Sub New()
        Me.Text = "GL Account Mappings"
        Me.Width = 820
        Me.Height = 520
        Dim top As New Panel() With {.Dock = DockStyle.Top, .Height = 44, .BackColor = Drawing.Color.White}
        Dim hdr As New Label() With {.Text = "GL Account Mappings", .Dock = DockStyle.Fill, .Font = New Drawing.Font("Segoe UI", 12, Drawing.FontStyle.Bold), .Padding = New Padding(12, 8, 12, 8)}
        top.Controls.Add(hdr)
        Controls.Add(top)

        Dim bottom As New Panel() With {.Dock = DockStyle.Bottom, .Height = 48}
        AddHandler btnSave.Click, AddressOf OnSave
        bottom.Controls.Add(btnSave)
        Controls.Add(bottom)

        ' Build grid
        grid.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Mapping Key", .DataPropertyName = "MappingKey", .Width = 200})
        Dim colBranch As New DataGridViewTextBoxColumn() With {.HeaderText = "BranchID (optional)", .DataPropertyName = "BranchID", .Width = 140}
        grid.Columns.Add(colBranch)
        Dim colAcct As New DataGridViewComboBoxColumn() With {.HeaderText = "Account", .DataPropertyName = "AccountID", .Width = 420}
        grid.Columns.Add(colAcct)
        Controls.Add(grid)

        LoadData(colAcct)
    End Sub

    Private Sub LoadData(colAcct As DataGridViewComboBoxColumn)
        Using con As New SqlConnection(connectionString)
            con.Open()
            ' Accounts for dropdown (AccountID, Display as [Number] Name)
            accounts = New DataTable()
            Using cmd As New SqlCommand("SELECT AccountID, '[' + ISNULL(AccountNumber,'') + '] ' + AccountName AS Display FROM dbo.GLAccounts WHERE IsActive = 1 ORDER BY AccountNumber, AccountName", con)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(accounts)
                End Using
            End Using

            colAcct.DataSource = accounts
            colAcct.ValueMember = "AccountID"
            colAcct.DisplayMember = "Display"

            ' Load or create base mappings
            mappings = New DataTable()
            Using cmd As New SqlCommand("SELECT MappingKey, BranchID, AccountID FROM dbo.GLAccountMappings ORDER BY MappingKey, BranchID", con)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(mappings)
                End Using
            End Using

            If mappings.Rows.Count = 0 Then
                ' Seed keys with nulls so user can choose
                Dim keys = New String() {"Purchases", "VATInput", "Creditors", "SupplierDebtors", "PayrollExpense", "PayrollLiability", "Bank"}
                For Each k In keys
                    Dim r = mappings.NewRow()
                    r("MappingKey") = k
                    r("BranchID") = DBNull.Value
                    r("AccountID") = DBNull.Value
                    mappings.Rows.Add(r)
                Next
            End If

            grid.DataSource = mappings
        End Using
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            grid.EndEdit()
            Using con As New SqlConnection(connectionString)
                con.Open()
                For Each r As DataRow In mappings.Rows
                    Dim key As String = Convert.ToString(r("MappingKey")).Trim()
                    If String.IsNullOrEmpty(key) Then Continue For
                    Dim branchIdObj As Object = If(IsDBNull(r("BranchID")), DBNull.Value, r("BranchID"))
                    Dim acctObj As Object = If(IsDBNull(r("AccountID")) OrElse Convert.ToInt32(r("AccountID")) = 0, DBNull.Value, r("AccountID"))

                    ' Upsert: delete then insert
                    Using del As New SqlCommand("DELETE FROM dbo.GLAccountMappings WHERE MappingKey = @k AND ( (BranchID IS NULL AND @b IS NULL) OR BranchID = @b )", con)
                        del.Parameters.AddWithValue("@k", key)
                        Dim pB = del.Parameters.Add("@b", SqlDbType.Int)
                        If branchIdObj Is DBNull.Value Then pB.Value = DBNull.Value Else pB.Value = Convert.ToInt32(branchIdObj)
                        del.ExecuteNonQuery()
                    End Using

                    Using ins As New SqlCommand("INSERT INTO dbo.GLAccountMappings (MappingKey, BranchID, AccountID, ModifiedBy) VALUES (@k, @b, @a, @u)", con)
                        ins.Parameters.AddWithValue("@k", key)
                        Dim pB = ins.Parameters.Add("@b", SqlDbType.Int)
                        If branchIdObj Is DBNull.Value Then pB.Value = DBNull.Value Else pB.Value = Convert.ToInt32(branchIdObj)
                        Dim pA = ins.Parameters.Add("@a", SqlDbType.Int)
                        If acctObj Is DBNull.Value Then pA.Value = DBNull.Value Else pA.Value = Convert.ToInt32(acctObj)
                        ins.Parameters.AddWithValue("@u", AppSession.CurrentUserID)
                        ins.ExecuteNonQuery()
                    End Using
                Next
            End Using
            MessageBox.Show("Mappings saved.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
