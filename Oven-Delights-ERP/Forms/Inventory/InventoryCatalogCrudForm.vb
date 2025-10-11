Imports System.Data
Imports System.Windows.Forms

Public Class InventoryCatalogCrudForm
    Inherits Form

    Private ReadOnly svc As New StockroomService()
    Private ReadOnly catalogType As String ' Types: Internal Product, External Product, SubAssembly, Decoration, Topping, Accessory, Packaging

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnDelete As Button
    Private btnSave As Button
    Private btnClose As Button

    Public Sub New(typeName As String)
        catalogType = typeName
        Me.Text = $"Manage {catalogType}s"
        Me.Width = 1000
        Me.Height = 650
        InitializeComponent()
        LoadCatalog()
    End Sub

    Private Sub OnDelete(sender As Object, e As EventArgs)
        If dgv.CurrentRow Is Nothing OrElse dgv.DataSource Is Nothing Then Return
        Dim tbl = TryCast(dgv.DataSource, DataTable)
        If tbl Is Nothing Then Return
        Dim drv = TryCast(dgv.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return
        Dim r As DataRow = drv.Row
        If r Is Nothing Then Return

        Dim id As Integer = 0
        If r.Table.Columns.Contains("ID") AndAlso Not r.IsNull("ID") Then
            Integer.TryParse(Convert.ToString(r("ID")), id)
        End If

        If id > 0 Then
            If r.Table.Columns.Contains("IsActive") Then
                r("IsActive") = False
                MessageBox.Show("Row marked inactive. Click Save to persist.")
            End If
        Else
            Try
                tbl.Rows.Remove(r)
            Catch
                Try
                    r.Delete()
                Catch
                End Try
            End Try
        End If
    End Sub

    Private Sub InitializeComponent()
        dgv = New DataGridView() With { .Dock = DockStyle.Fill, .AutoGenerateColumns = False, .AllowUserToAddRows = False }
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "ID", .DataPropertyName = "ID", .Name = "ID", .Visible = False})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Code", .DataPropertyName = "ItemCode", .Name = "ItemCode", .Width = 160})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Name", .DataPropertyName = "ItemName", .Name = "ItemName", .Width = 300})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Current Cost", .DataPropertyName = "CurrentCost", .Name = "CurrentCost", .Width = 110, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Last Paid", .DataPropertyName = "LastPaidCost", .Name = "LastPaidCost", .Width = 110, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Last Purchase Date", .DataPropertyName = "LastPurchaseDate", .Name = "LastPurchaseDate", .Width = 150, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "yyyy-MM-dd"}})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Last SupplierID", .DataPropertyName = "LastSupplierID", .Name = "LastSupplierID", .Width = 120})
        dgv.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Active", .DataPropertyName = "IsActive", .Name = "IsActive", .Width = 70})

        btnAdd = New Button() With {.Text = "Add New", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnDelete = New Button() With {.Text = "Delete", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnSave = New Button() With {.Text = "Save", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnClose = New Button() With {.Text = "Close", .Height = 34, .Dock = DockStyle.Left, .Width = 120}

        Dim topPanel As New FlowLayoutPanel() With {.Dock = DockStyle.Top, .Height = 44, .Padding = New Padding(8)}
        topPanel.Controls.AddRange(New Control() {btnAdd, btnDelete, btnSave, btnClose})

        AddHandler btnAdd.Click, AddressOf OnAdd
        AddHandler btnDelete.Click, AddressOf OnDelete
        AddHandler btnSave.Click, AddressOf OnSave
        AddHandler btnClose.Click, Sub(sender, e) Me.Close()
        dgv.EditMode = DataGridViewEditMode.EditOnKeystrokeOrF2
        dgv.SelectionMode = DataGridViewSelectionMode.CellSelect
        AddHandler dgv.DataError, Sub(s, e) e.ThrowException = False

        Me.Controls.Add(dgv)
        Me.Controls.Add(topPanel)

        ' Always-visible bottom footer with Save and Close
        Dim bottomPanel As New FlowLayoutPanel() With {
            .Dock = DockStyle.Bottom,
            .Height = 52,
            .Padding = New Padding(8),
            .FlowDirection = FlowDirection.RightToLeft,
            .BackColor = Color.White
        }
        Dim btnFooterClose As New Button() With {.Text = "Close", .Width = 120, .Height = 34}
        Dim btnFooterSave As New Button() With {.Text = "Save", .Width = 120, .Height = 34}
        AddHandler btnFooterSave.Click, AddressOf OnSave
        AddHandler btnFooterClose.Click, Sub(sender, e) Me.Close()
        bottomPanel.Controls.Add(btnFooterClose)
        bottomPanel.Controls.Add(btnFooterSave)
        Me.Controls.Add(bottomPanel)
    End Sub

    Private Sub LoadCatalog()
        Try
            ' Load data for the specific catalog type
            Dim data As DataTable = svc.GetCatalogData(catalogType)
            dgv.DataSource = data
        Catch ex As Exception
            MessageBox.Show($"Error loading {catalogType} catalog: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Dim tbl = CType(dgv.DataSource, DataTable)
        Dim r = tbl.NewRow()
        
        ' Set default values based on catalog type
        If tbl.Columns.Contains("Code") Then r("Code") = ""
        If tbl.Columns.Contains("Name") Then r("Name") = ""
        If tbl.Columns.Contains("Description") Then r("Description") = ""
        If tbl.Columns.Contains("IsActive") Then r("IsActive") = True
        If tbl.Columns.Contains("LedgerCode") Then r("LedgerCode") = ""
        
        ' Legacy columns for backward compatibility
        If tbl.Columns.Contains("ItemCode") Then r("ItemCode") = ""
        If tbl.Columns.Contains("ItemName") Then r("ItemName") = ""
        If tbl.Columns.Contains("CurrentCost") Then r("CurrentCost") = 0D
        If tbl.Columns.Contains("LastPaidCost") Then r("LastPaidCost") = DBNull.Value
        If tbl.Columns.Contains("LastPurchaseDate") Then r("LastPurchaseDate") = DBNull.Value
        If tbl.Columns.Contains("LastSupplierID") Then r("LastSupplierID") = DBNull.Value
        If tbl.Columns.Contains("UoMID") Then r("UoMID") = DBNull.Value
        
        tbl.Rows.Add(r)
        Dim idx As Integer = dgv.Rows.Count - 1
        If idx >= 0 Then
            Dim nameCol As String = If(tbl.Columns.Contains("Name"), "Name", "ItemName")
            If dgv.Columns.Contains(nameCol) Then
                dgv.CurrentCell = dgv.Rows(idx).Cells(nameCol)
                dgv.BeginEdit(True)
            End If
        End If
    End Sub

    ' Public helper so menus can force an immediate add after opening the form
    Public Sub AddNewItemRow()
        OnAdd(Me, EventArgs.Empty)
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        dgv.EndEdit()
        Dim tbl = CType(dgv.DataSource, DataTable)
        svc.SaveCatalogData(catalogType, tbl)
        LoadCatalog()
        MessageBox.Show("Saved.")
    End Sub
End Class
