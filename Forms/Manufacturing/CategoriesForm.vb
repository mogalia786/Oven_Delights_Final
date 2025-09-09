Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing

Namespace Manufacturing

Public Class CategoriesForm
    Inherits Form

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnEdit As Button
    Private btnDelete As Button
    Private btnRefresh As Button

    Public Sub New()
        Me.Text = "Categories"
        Me.Width = 800
        Me.Height = 520
        Me.StartPosition = FormStartPosition.CenterParent

        dgv = New DataGridView() With {
            .Left = 12, .Top = 52, .Width = 760, .Height = 420,
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

    Private Sub LoadData()
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim hasCreated = HasColumn(cn, "Categories", "CreatedDate")
                Dim hasModified = HasColumn(cn, "Categories", "ModifiedDate")
                Dim selectSql As String = "SELECT CategoryID, CategoryCode, CategoryName, IsActive" & _
                                          If(hasCreated, ", CreatedDate", ", NULL AS CreatedDate") & _
                                          If(hasModified, ", ModifiedDate", ", NULL AS ModifiedDate") & _
                                          " FROM dbo.Categories ORDER BY CategoryName"
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

    Private Function HasColumn(cn As SqlConnection, tableName As String, columnName As String) As Boolean
        Using cmd As New SqlCommand("SELECT CASE WHEN COL_LENGTH(@t, @c) IS NULL THEN 0 ELSE 1 END", cn)
            cmd.Parameters.AddWithValue("@t", "dbo." & tableName)
            cmd.Parameters.AddWithValue("@c", columnName)
            Return Convert.ToInt32(cmd.ExecuteScalar()) = 1
        End Using
    End Function

    Private Function SelectedId() As Integer
        If dgv Is Nothing OrElse dgv.CurrentRow Is Nothing OrElse dgv.CurrentRow.DataBoundItem Is Nothing Then Return 0
        Dim drv = TryCast(dgv.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return 0
        If drv.Row.Table.Columns.Contains("CategoryID") AndAlso drv.Row("CategoryID") IsNot DBNull.Value Then
            Return Convert.ToInt32(drv.Row("CategoryID"))
        End If
        Return 0
    End Function

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadData()
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Dim code = InputBox("Category Code:", "Add Category").Trim()
        If String.IsNullOrWhiteSpace(code) Then Return
        Dim name = InputBox("Category Name:", "Add Category").Trim()
        If String.IsNullOrWhiteSpace(name) Then Return
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Using cmd As New SqlCommand("INSERT INTO dbo.Categories(CategoryCode, CategoryName, IsActive) VALUES(@c,@n,1)", cn)
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
        Dim code = InputBox("New Category Code (leave blank to keep):", "Edit Category").Trim()
        Dim name = InputBox("New Category Name (leave blank to keep):", "Edit Category").Trim()
        Dim toggleActive = MessageBox.Show("Toggle Active?", "Edit Category", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Dim hasModified = HasColumn(cn, "Categories", "ModifiedDate")
                Dim sql As String = "UPDATE dbo.Categories SET " & _
                                    "CategoryCode = COALESCE(NULLIF(@c,''), CategoryCode), " & _
                                    "CategoryName = COALESCE(NULLIF(@n,''), CategoryName), " & _
                                    "IsActive = CASE WHEN @t=1 THEN CAST(1-CAST(IsActive AS INT) AS BIT) ELSE IsActive END" & _
                                    If(hasModified, ", ModifiedDate = GETDATE()", "") & _
                                    " WHERE CategoryID=@id"
                Using cmd As New SqlCommand(sql, cn)
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
        If MessageBox.Show("Delete this category? (Will fail if in use)", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) <> DialogResult.Yes Then Return
        Try
            Using cn As New SqlConnection(CS())
                cn.Open()
                Using cmd As New SqlCommand("DELETE FROM dbo.Categories WHERE CategoryID=@id", cn)
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
