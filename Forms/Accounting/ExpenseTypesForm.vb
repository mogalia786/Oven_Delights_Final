Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing

Namespace Accounting

Public Class ExpenseTypesForm
    Inherits Form

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnEdit As Button
    Private btnDelete As Button
    Private btnRefresh As Button

    Public Sub New()
        Me.Text = "Expense Types"
        Me.Width = 900
        Me.Height = 560
        Me.StartPosition = FormStartPosition.CenterParent

        dgv = New DataGridView() With {
            .Left = 12, .Top = 52, .Width = 860, .Height = 460,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False
        }

        btnAdd = New Button() With {.Left = 12, .Top = 12, .Width = 90, .Text = "Add"}
        btnEdit = New Button() With {.Left = 108, .Top = 12, .Width = 90, .Text = "Edit"}
        btnDelete = New Button() With {.Left = 204, .Top = 12, .Width = 90, .Text = "Delete"}
        btnRefresh = New Button() With {.Left = 300, .Top = 12, .Width = 90, .Text = "Refresh"}

        AddHandler btnAdd.Click, AddressOf OnAdd
        AddHandler btnEdit.Click, AddressOf OnEdit
        AddHandler btnDelete.Click, AddressOf OnDelete
        AddHandler btnRefresh.Click, AddressOf OnRefresh

        Controls.AddRange(New Control() {btnAdd, btnEdit, btnDelete, btnRefresh, dgv})

        LoadData()
        AddHandler Me.Shown, Sub(sender, args) LoadData()
        AddHandler Me.Activated, Sub(sender, args) LoadData()
    End Sub

    Private Function CS() As String
        Return System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Function

    Private Function HasColumn(cn As SqlConnection, tableName As String, columnName As String) As Boolean
        Using cmd As New SqlCommand("SELECT CASE WHEN COL_LENGTH(@t, @c) IS NULL THEN 0 ELSE 1 END", cn)
            cmd.Parameters.AddWithValue("@t", "dbo." & tableName)
            cmd.Parameters.AddWithValue("@c", columnName)
            Return Convert.ToInt32(cmd.ExecuteScalar()) = 1
        End Using
    End Function

    Private Sub LoadData()
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim hasETCode = HasColumn(cn, "ExpenseTypes", "ExpenseTypeCode")
                Dim hasCode = HasColumn(cn, "ExpenseTypes", "Code")
                Dim hasETName = HasColumn(cn, "ExpenseTypes", "ExpenseTypeName")
                Dim hasName = HasColumn(cn, "ExpenseTypes", "Name")
                Dim hasGroup = HasColumn(cn, "ExpenseTypes", "TypeGroup")

                Dim selectSql As String = "SELECT ExpenseTypeID, " & _
                    If(hasETCode, "ExpenseTypeCode", If(hasCode, "Code AS ExpenseTypeCode", "CAST(NULL AS VARCHAR(12)) AS ExpenseTypeCode")) & ", " & _
                    If(hasETName, "ExpenseTypeName", If(hasName, "Name AS ExpenseTypeName", "CAST(NULL AS NVARCHAR(100)) AS ExpenseTypeName")) & ", " & _
                    If(hasGroup, "TypeGroup", "CAST(NULL AS VARCHAR(12)) AS TypeGroup") & ", IsActive, " & _
                    If(HasColumn(cn, "ExpenseTypes", "CreatedDate"), "CreatedDate", "NULL AS CreatedDate") & ", " & _
                    If(HasColumn(cn, "ExpenseTypes", "ModifiedDate"), "ModifiedDate", "NULL AS ModifiedDate") & _
                    " FROM dbo.ExpenseTypes ORDER BY " & _
                    "COALESCE(" & If(hasETName, "ExpenseTypeName", "NULL") & ", " & If(hasName, "Name", "NULL") & ")"

                Using cmd As New SqlCommand(selectSql, cn)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgv.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Load failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function SelectedId() As Integer
        If dgv Is Nothing OrElse dgv.CurrentRow Is Nothing OrElse dgv.CurrentRow.DataBoundItem Is Nothing Then Return 0
        Dim drv = TryCast(dgv.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return 0
        If drv.Row.Table.Columns.Contains("ExpenseTypeID") AndAlso drv.Row("ExpenseTypeID") IsNot DBNull.Value Then
            Return Convert.ToInt32(drv.Row("ExpenseTypeID"))
        End If
        Return 0
    End Function

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadData()
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Dim code = InputBox("Code:", "Add Expense Type").Trim()
        If String.IsNullOrWhiteSpace(code) Then Return
        Dim name = InputBox("Name:", "Add Expense Type").Trim()
        If String.IsNullOrWhiteSpace(name) Then Return
        Dim groupVal = InputBox("Group (Expense/Income/Other):", "Add Expense Type", "Expense").Trim()
        If String.IsNullOrWhiteSpace(groupVal) Then groupVal = "Expense"
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim hasETCode = HasColumn(cn, "ExpenseTypes", "ExpenseTypeCode")
                Dim hasETName = HasColumn(cn, "ExpenseTypes", "ExpenseTypeName")
                Dim hasGroup = HasColumn(cn, "ExpenseTypes", "TypeGroup")
                Dim hasCode = HasColumn(cn, "ExpenseTypes", "Code")
                Dim hasName = HasColumn(cn, "ExpenseTypes", "Name")

                ' Build INSERT to write into both sets if both exist and may be NOT NULL
                Dim cols As New List(Of String)()
                Dim vals As New List(Of String)()
                If hasETCode Then cols.Add("ExpenseTypeCode") : vals.Add("@c")
                If hasCode Then cols.Add("Code") : vals.Add("@c")
                If hasETName Then cols.Add("ExpenseTypeName") : vals.Add("@n")
                If hasName Then cols.Add("Name") : vals.Add("@n")
                If hasGroup Then cols.Add("TypeGroup") : vals.Add("@g")
                cols.Add("IsActive") : vals.Add("1")

                If cols.Count = 0 Then Throw New Exception("ExpenseTypes table missing expected columns.")

                Dim sql As String = "INSERT INTO dbo.ExpenseTypes(" & String.Join(", ", cols) & ") VALUES(" & String.Join(", ", vals) & ")"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@n", name)
                    If hasGroup Then cmd.Parameters.AddWithValue("@g", groupVal)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadData()
        Catch ex As Exception
            MessageBox.Show("Add failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnEdit(sender As Object, e As EventArgs)
        Dim id = SelectedId()
        If id <= 0 Then
            MessageBox.Show("Select a row.", "Edit", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Dim code = InputBox("New Code (blank to keep):", "Edit Expense Type").Trim()
        Dim name = InputBox("New Name (blank to keep):", "Edit Expense Type").Trim()
        Dim groupVal = InputBox("New Group (blank to keep):", "Edit Expense Type").Trim()
        Dim toggleActive = MessageBox.Show("Toggle Active?", "Edit Expense Type", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim hasETCode = HasColumn(cn, "ExpenseTypes", "ExpenseTypeCode")
                Dim hasETName = HasColumn(cn, "ExpenseTypes", "ExpenseTypeName")
                Dim hasGroup = HasColumn(cn, "ExpenseTypes", "TypeGroup")
                Dim hasCode = HasColumn(cn, "ExpenseTypes", "Code")
                Dim hasName = HasColumn(cn, "ExpenseTypes", "Name")

                Dim sets As New List(Of String)()
                If hasETCode Then sets.Add("ExpenseTypeCode = COALESCE(NULLIF(@c,''), ExpenseTypeCode)")
                If hasCode Then sets.Add("Code = COALESCE(NULLIF(@c,''), Code)")
                If hasETName Then sets.Add("ExpenseTypeName = COALESCE(NULLIF(@n,''), ExpenseTypeName)")
                If hasName Then sets.Add("Name = COALESCE(NULLIF(@n,''), Name)")
                If hasGroup Then
                    sets.Add("TypeGroup = COALESCE(NULLIF(@g,''), TypeGroup)")
                End If
                sets.Add("IsActive = CASE WHEN @t=1 THEN CAST(1-CAST(IsActive AS INT) AS BIT) ELSE IsActive END")
                If HasColumn(cn, "ExpenseTypes", "ModifiedDate") Then
                    sets.Add("ModifiedDate = GETDATE()")
                End If

                Dim sql As String = "UPDATE dbo.ExpenseTypes SET " & String.Join(", ", sets) & " WHERE ExpenseTypeID=@id"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@n", name)
                    If hasGroup Then cmd.Parameters.AddWithValue("@g", groupVal)
                    cmd.Parameters.AddWithValue("@t", If(toggleActive, 1, 0))
                    cmd.Parameters.AddWithValue("@id", id)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadData()
        Catch ex As Exception
            MessageBox.Show("Edit failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnDelete(sender As Object, e As EventArgs)
        Dim id = SelectedId()
        If id <= 0 Then
            MessageBox.Show("Select a row.", "Delete", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If MessageBox.Show("Delete this type? (Will fail if in use)", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) <> DialogResult.Yes Then Return
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Using cmd As New SqlCommand("DELETE FROM dbo.ExpenseTypes WHERE ExpenseTypeID=@id", cn)
                    cmd.Parameters.AddWithValue("@id", id)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadData()
        Catch ex As Exception
            MessageBox.Show("Delete failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Class

End Namespace
