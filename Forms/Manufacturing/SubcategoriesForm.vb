Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing

Namespace Manufacturing

Public Class SubcategoriesForm
    Inherits Form

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnEdit As Button
    Private btnDelete As Button
    Private btnRefresh As Button

    Public Sub New()
        Me.Text = "Subcategories"
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
                Dim sql As String = _
                    "SELECT s.SubcategoryID, s.SubcategoryCode, s.SubcategoryName, s.IsActive, " & _
                    "c.CategoryID, c.CategoryCode, c.CategoryName " & _
                    "FROM dbo.Subcategories s JOIN dbo.Categories c ON c.CategoryID=s.CategoryID " & _
                    "ORDER BY c.CategoryName, s.SubcategoryName"
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
        If drv.Row.Table.Columns.Contains("SubcategoryID") AndAlso drv.Row("SubcategoryID") IsNot DBNull.Value Then
            Return Convert.ToInt32(drv.Row("SubcategoryID"))
        End If
        Return 0
    End Function

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadData()
    End Sub

    Private Function PickCategory(cn As SqlConnection) As Integer
        Using cmd As New SqlCommand("SELECT CategoryID, CategoryName FROM dbo.Categories WHERE IsActive=1 ORDER BY CategoryName", cn)
            Using da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count = 0 Then
                    MessageBox.Show("No categories exist.", "Pick Category", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return 0
                End If
                Dim names = dt.AsEnumerable().Select(Function(row) row.Field(Of String)("CategoryName")).ToArray()
                Dim sel = InputBox("Category Name (type exact):" & Environment.NewLine & String.Join(Environment.NewLine, names), "Pick Category").Trim()
                If String.IsNullOrWhiteSpace(sel) Then Return 0
                Dim matchRow = dt.AsEnumerable().FirstOrDefault(Function(x) String.Equals(x.Field(Of String)("CategoryName"), sel, StringComparison.OrdinalIgnoreCase))
                If matchRow Is Nothing Then Return 0
                Return Convert.ToInt32(matchRow("CategoryID"))
            End Using
        End Using
    End Function

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim catId = PickCategory(cn)
                If catId <= 0 Then Return
                Dim code = InputBox("Subcategory Code:", "Add Subcategory").Trim()
                If String.IsNullOrWhiteSpace(code) Then Return
                Dim name = InputBox("Subcategory Name:", "Add Subcategory").Trim()
                If String.IsNullOrWhiteSpace(name) Then Return
                Using cmd As New SqlCommand("INSERT INTO dbo.Subcategories(CategoryID, SubcategoryCode, SubcategoryName, IsActive) VALUES(@cId,@c,@n,1)", cn)
                    cmd.Parameters.AddWithValue("@cId", catId)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@n", name)
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
                Dim changeCat = MessageBox.Show("Change Category?", "Edit Subcategory", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
                Dim newCatId As Integer = 0
                If changeCat Then
                    newCatId = PickCategory(cn)
                    If newCatId <= 0 Then Return
                End If
                Dim code = InputBox("New Subcategory Code (blank to keep):", "Edit Subcategory").Trim()
                Dim name = InputBox("New Subcategory Name (blank to keep):", "Edit Subcategory").Trim()
                Dim toggleActive = MessageBox.Show("Toggle Active?", "Edit Subcategory", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
                Dim hasModified = HasColumn(cn, "Subcategories", "ModifiedDate")
                Dim sql As String = "UPDATE dbo.Subcategories SET " & _
                                    "CategoryID = COALESCE(NULLIF(@newCat,0), CategoryID), " & _
                                    "SubcategoryCode = COALESCE(NULLIF(@c,''), SubcategoryCode), " & _
                                    "SubcategoryName = COALESCE(NULLIF(@n,''), SubcategoryName), " & _
                                    "IsActive = CASE WHEN @t=1 THEN CAST(1-CAST(IsActive AS INT) AS BIT) ELSE IsActive END" & _
                                    If(hasModified, ", ModifiedDate = GETDATE()", "") & _
                                    " WHERE SubcategoryID=@id"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@newCat", newCatId)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@n", name)
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
        If MessageBox.Show("Delete this subcategory? (Will fail if in use)", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) <> DialogResult.Yes Then Return
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Using cmd As New SqlCommand("DELETE FROM dbo.Subcategories WHERE SubcategoryID=@id", cn)
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
