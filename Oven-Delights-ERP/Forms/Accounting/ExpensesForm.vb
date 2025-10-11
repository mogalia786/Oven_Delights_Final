Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing

Namespace Accounting

Public Class ExpensesForm
    Inherits Form

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnEdit As Button
    Private btnDelete As Button
    Private btnRefresh As Button

    Public Sub New()
        Me.Text = "Expenses"
        Me.Width = 1100
        Me.Height = 620
        Me.StartPosition = FormStartPosition.CenterParent

        dgv = New DataGridView() With {
            .Left = 12, .Top = 52, .Width = 1060, .Height = 520,
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
                Dim hasETName = HasColumn(cn, "ExpenseTypes", "ExpenseTypeName")
                Dim hasName = HasColumn(cn, "ExpenseTypes", "Name")
                Dim hasGroup = HasColumn(cn, "ExpenseTypes", "TypeGroup")
                Dim etNameSel As String = If(hasETName, "et.ExpenseTypeName", If(hasName, "et.Name", "CAST(NULL AS NVARCHAR(100))")) & " AS ExpenseTypeName"
                Dim etGroupSel As String = If(hasGroup, "et.TypeGroup", "CAST(NULL AS VARCHAR(12))") & " AS TypeGroup"

                Dim sql As String = _
                    "SELECT e.ExpenseID, e.ExpenseCode, e.ExpenseName, e.IsActive, e.Notes, " & _
                    "       " & etNameSel & ", " & etGroupSel & ", " & _
                    "       c.CategoryName, s.SubcategoryName, " & _
                    "       e.CreatedDate, e.ModifiedDate " & _
                    "FROM dbo.Expenses e " & _
                    "JOIN dbo.ExpenseTypes et ON et.ExpenseTypeID = e.ExpenseTypeID " & _
                    "LEFT JOIN dbo.Categories c ON c.CategoryID = e.CategoryID " & _
                    "LEFT JOIN dbo.Subcategories s ON s.SubcategoryID = e.SubcategoryID " & _
                    "ORDER BY e.ExpenseName"
                Using cmd As New SqlCommand(sql, cn)
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
        If drv.Row.Table.Columns.Contains("ExpenseID") AndAlso drv.Row("ExpenseID") IsNot DBNull.Value Then
            Return Convert.ToInt32(drv.Row("ExpenseID"))
        End If
        Return 0
    End Function

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadData()
    End Sub

    Private Function PickExpenseType(cn As SqlConnection) As Integer
        Dim hasETName = HasColumn(cn, "ExpenseCategories", "CategoryName")
        Dim hasName = HasColumn(cn, "ExpenseCategories", "Name")
        Dim colExpr As String = If(hasETName, "CategoryName", If(hasName, "Name", Nothing))
        If colExpr Is Nothing Then
            MessageBox.Show("ExpenseCategories schema missing name columns.", "Pick Expense Type", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return 0
        End If
        Using cmd As New SqlCommand($"SELECT CategoryID AS ExpenseTypeID, {colExpr} AS ExpenseTypeName FROM dbo.ExpenseCategories WHERE IsActive=1 ORDER BY {colExpr}", cn)
            Using da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count = 0 Then
                    MessageBox.Show("No expense categories exist.", "Pick Expense Type", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return 0
                End If
                Dim names = dt.AsEnumerable().Select(Function(row) row.Field(Of String)("ExpenseTypeName")).ToArray()
                Dim sel = InputBox("Expense Type (type exact):" & Environment.NewLine & String.Join(Environment.NewLine, names), "Pick Expense Type").Trim()
                If String.IsNullOrWhiteSpace(sel) Then Return 0
                Dim matchRow = dt.AsEnumerable().FirstOrDefault(Function(x) String.Equals(x.Field(Of String)("ExpenseTypeName"), sel, StringComparison.OrdinalIgnoreCase))
                If matchRow Is Nothing Then Return 0
                Return Convert.ToInt32(matchRow("ExpenseTypeID"))
            End Using
        End Using
    End Function

    Private Function PickCategory(cn As SqlConnection) As Integer
        Using cmd As New SqlCommand("SELECT CategoryID, CategoryName FROM dbo.Categories WHERE IsActive=1 ORDER BY CategoryName", cn)
            Using da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count = 0 Then Return 0
                Dim names = dt.AsEnumerable().Select(Function(row) row.Field(Of String)("CategoryName")).ToArray()
                Dim sel = InputBox("Category (type exact or blank for none):" & Environment.NewLine & String.Join(Environment.NewLine, names), "Pick Category").Trim()
                If String.IsNullOrWhiteSpace(sel) Then Return 0
                Dim matchRow = dt.AsEnumerable().FirstOrDefault(Function(x) String.Equals(x.Field(Of String)("CategoryName"), sel, StringComparison.OrdinalIgnoreCase))
                If matchRow Is Nothing Then Return 0
                Return Convert.ToInt32(matchRow("CategoryID"))
            End Using
        End Using
    End Function

    Private Function PickSubcategory(cn As SqlConnection, categoryId As Integer) As Integer
        If categoryId <= 0 Then Return 0
        Using cmd As New SqlCommand("SELECT SubcategoryID, SubcategoryName FROM dbo.Subcategories WHERE IsActive=1 AND CategoryID=@cid ORDER BY SubcategoryName", cn)
            cmd.Parameters.AddWithValue("@cid", categoryId)
            Using da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count = 0 Then Return 0
                Dim names = dt.AsEnumerable().Select(Function(row) row.Field(Of String)("SubcategoryName")).ToArray()
                Dim sel = InputBox("Subcategory (type exact or blank for none):" & Environment.NewLine & String.Join(Environment.NewLine, names), "Pick Subcategory").Trim()
                If String.IsNullOrWhiteSpace(sel) Then Return 0
                Dim matchRow = dt.AsEnumerable().FirstOrDefault(Function(x) String.Equals(x.Field(Of String)("SubcategoryName"), sel, StringComparison.OrdinalIgnoreCase))
                If matchRow Is Nothing Then Return 0
                Return Convert.ToInt32(matchRow("SubcategoryID"))
            End Using
        End Using
    End Function

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim typeId = PickExpenseType(cn)
                If typeId <= 0 Then Return
                Dim code = InputBox("Expense Code:", "Add Expense").Trim()
                If String.IsNullOrWhiteSpace(code) Then Return
                Dim name = InputBox("Expense Name:", "Add Expense").Trim()
                If String.IsNullOrWhiteSpace(name) Then Return
                Dim catId = PickCategory(cn)
                Dim subId = PickSubcategory(cn, catId)
                Dim notes = InputBox("Notes (optional):", "Add Expense").Trim()
                Using cmd As New SqlCommand("INSERT INTO dbo.Expenses(ExpenseCode, ExpenseName, ExpenseTypeID, CategoryID, SubcategoryID, IsActive, Notes) VALUES(@c,@n,@tid,@cid,@sid,1,@notes)", cn)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@n", name)
                    cmd.Parameters.AddWithValue("@tid", typeId)
                    cmd.Parameters.AddWithValue("@cid", If(catId > 0, CType(catId, Object), DBNull.Value))
                    cmd.Parameters.AddWithValue("@sid", If(subId > 0, CType(subId, Object), DBNull.Value))
                    cmd.Parameters.AddWithValue("@notes", If(notes.Length > 0, CType(notes, Object), DBNull.Value))
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
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim changeType = MessageBox.Show("Change Expense Type?", "Edit Expense", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
                Dim newTypeId As Integer = 0
                If changeType Then
                    newTypeId = PickExpenseType(cn)
                    If newTypeId <= 0 Then Return
                End If
                Dim changeCat = MessageBox.Show("Change Category/Subcategory?", "Edit Expense", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
                Dim newCatId As Integer = 0
                Dim newSubId As Integer = 0
                If changeCat Then
                    newCatId = PickCategory(cn)
                    newSubId = PickSubcategory(cn, newCatId)
                End If
                Dim code = InputBox("New Code (blank to keep):", "Edit Expense").Trim()
                Dim name = InputBox("New Name (blank to keep):", "Edit Expense").Trim()
                Dim notes = InputBox("New Notes (blank to keep):", "Edit Expense").Trim()
                Dim toggleActive = MessageBox.Show("Toggle Active?", "Edit Expense", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
                Dim sql As String = "UPDATE dbo.Expenses SET " & _
                                    "ExpenseCode = COALESCE(NULLIF(@c,''), ExpenseCode), " & _
                                    "ExpenseName = COALESCE(NULLIF(@n,''), ExpenseName), " & _
                                    "ExpenseTypeID = COALESCE(NULLIF(@tid,0), ExpenseTypeID), " & _
                                    "CategoryID = CASE WHEN @cid=0 THEN NULL ELSE COALESCE(NULLIF(@cid,0), CategoryID) END, " & _
                                    "SubcategoryID = CASE WHEN @sid=0 THEN NULL ELSE COALESCE(NULLIF(@sid,0), SubcategoryID) END, " & _
                                    "Notes = COALESCE(NULLIF(@notes,''), Notes), " & _
                                    "IsActive = CASE WHEN @t=1 THEN CAST(1-CAST(IsActive AS INT) AS BIT) ELSE IsActive END, " & _
                                    "ModifiedDate = GETDATE() WHERE ExpenseID=@id"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@n", name)
                    cmd.Parameters.AddWithValue("@tid", newTypeId)
                    cmd.Parameters.AddWithValue("@cid", newCatId)
                    cmd.Parameters.AddWithValue("@sid", newSubId)
                    cmd.Parameters.AddWithValue("@notes", notes)
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
        If MessageBox.Show("Delete this expense? (Will fail if in use)", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) <> DialogResult.Yes Then Return
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Using cmd As New SqlCommand("DELETE FROM dbo.Expenses WHERE ExpenseID=@id", cn)
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
