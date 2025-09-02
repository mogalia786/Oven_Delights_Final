Imports System.Data
Imports System.Windows.Forms

Public Class InventoryCatalogCrudForm
    Inherits Form

    Private ReadOnly svc As New StockroomService()
    Private ReadOnly catalogType As String ' RawMaterial not used here; types: SubAssembly, Decoration, Topping, Accessory, Packaging

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
        Dim dt As DataTable = svc.GetCatalogItems(catalogType)
        dgv.DataSource = dt

        ' Add UoM dropdown if UoMID is present and column not already added
        Dim hasUoM As Boolean = dt IsNot Nothing AndAlso dt.Columns.Contains("UoMID")
        If hasUoM AndAlso dgv.Columns("UoMID") Is Nothing Then
            Dim units As DataTable = svc.GetUnits()
            Dim col As New DataGridViewComboBoxColumn()
            col.Name = "UoMID"
            col.HeaderText = "Unit"
            col.DataPropertyName = "UoMID"
            col.DisplayMember = "UnitName"
            col.ValueMember = "UoMID"
            col.DataSource = units
            col.Width = 100
            ' Insert before Active column if available
            Dim insertIndex As Integer = dgv.Columns.Count
            If dgv.Columns.Contains("IsActive") Then insertIndex = dgv.Columns("IsActive").Index
            dgv.Columns.Insert(insertIndex, col)
        End If
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Dim tbl = CType(dgv.DataSource, DataTable)
        Dim r = tbl.NewRow()
        r("ItemCode") = ""
        r("ItemName") = ""
        r("IsActive") = True
        r("CurrentCost") = 0D
        r("LastPaidCost") = DBNull.Value
        r("LastPurchaseDate") = DBNull.Value
        r("LastSupplierID") = DBNull.Value
        If tbl.Columns.Contains("UoMID") Then r("UoMID") = DBNull.Value
        tbl.Rows.Add(r)
        Dim idx As Integer = dgv.Rows.Count - 1
        If idx >= 0 Then
            dgv.CurrentCell = dgv.Rows(idx).Cells("ItemName")
            dgv.BeginEdit(True)
        End If
    End Sub

    ' Public helper so menus can force an immediate add after opening the form
    Public Sub AddNewItemRow()
        OnAdd(Me, EventArgs.Empty)
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        dgv.EndEdit()
        Dim tbl = CType(dgv.DataSource, DataTable)
        svc.SaveCatalogItems(catalogType, tbl)
        LoadCatalog()
        MessageBox.Show("Saved.")
    End Sub
End Class
