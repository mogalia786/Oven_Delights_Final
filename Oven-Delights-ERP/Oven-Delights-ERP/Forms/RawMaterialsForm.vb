Imports System.Data
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Public Class RawMaterialsForm
    Inherits Form
    Implements UI.ISidebarProvider

    Private ReadOnly svc As New StockroomService()

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnSave As Button
    Private btnClose As Button
    Private btnDelete As Button

    Public Sub New()
        Me.Text = "Materials"
        Me.Width = 1000
        Me.Height = 650
        InitializeComponent()
        Theme.Apply(Me)
        Theme.StylePrimaryButton(btnAdd)
        Theme.StyleSecondaryButton(btnSave)
        Theme.StyleSecondaryButton(btnClose)
        Theme.StyleGrid(dgv)
        LoadMaterials()
        ' Notify sidebar to build context when this form becomes active
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub InitializeComponent()
        dgv = New DataGridView() With { .Dock = DockStyle.Fill, .AutoGenerateColumns = False, .AllowUserToAddRows = False }
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "ID", .DataPropertyName = "MaterialID", .Name = "MaterialID", .Visible = False})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Code", .DataPropertyName = "MaterialCode", .Name = "MaterialCode", .Width = 120})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Name", .DataPropertyName = "MaterialName", .Name = "MaterialName", .Width = 260})
        dgv.Columns.Add(New DataGridViewComboBoxColumn() With {.HeaderText = "Type", .DataPropertyName = "MaterialType", .Name = "MaterialType", .Width = 120, .DataSource = New String() {"Raw", "NonRaw"}})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "UoM", .DataPropertyName = "UnitOfMeasure", .Name = "UnitOfMeasure", .Width = 100})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Last Cost", .DataPropertyName = "LastCost", .Name = "LastCost", .Width = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Avg Cost", .DataPropertyName = "AverageCost", .Name = "AverageCost", .Width = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Stock", .DataPropertyName = "CurrentStock", .Name = "CurrentStock", .Width = 90, .ReadOnly = True})
        dgv.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Active", .DataPropertyName = "IsActive", .Name = "IsActive", .Width = 70})

        btnAdd = New Button() With {.Text = "Add New", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnDelete = New Button() With {.Text = "Delete", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnSave = New Button() With {.Text = "Save", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnClose = New Button() With {.Text = "Close", .Height = 34, .Dock = DockStyle.Left, .Width = 120}

        Dim topPanel As New FlowLayoutPanel() With {.Dock = DockStyle.Top, .Height = 44, .Padding = New Padding(8)}
        topPanel.Controls.AddRange(New Control() {btnAdd, btnDelete, btnSave, btnClose})

        ' Bottom action bar with Save & Close
        Dim bottomPanel As New Panel() With {.Dock = DockStyle.Bottom, .Height = 50}
        Dim btnSaveClose As New Button() With {.Text = "Save && Close", .Height = 34, .Width = 140, .Anchor = AnchorStyles.Right Or AnchorStyles.Bottom}
        AddHandler btnSaveClose.Click, Sub(sender, e)
                                           OnSave(sender, e)
                                           Me.Close()
                                       End Sub
        ' position button to the right
        btnSaveClose.Left = Me.ClientSize.Width - btnSaveClose.Width - 16
        btnSaveClose.Top = 8
        btnSaveClose.Anchor = AnchorStyles.Right Or AnchorStyles.Bottom
        bottomPanel.Controls.Add(btnSaveClose)

        AddHandler btnAdd.Click, AddressOf OnAdd
        AddHandler btnSave.Click, AddressOf OnSave
        AddHandler btnDelete.Click, AddressOf OnDelete
        AddHandler btnClose.Click, Sub(sender, e) Me.Close()
        dgv.EditMode = DataGridViewEditMode.EditOnKeystrokeOrF2
        dgv.SelectionMode = DataGridViewSelectionMode.CellSelect
        AddHandler dgv.DataError, AddressOf OnGridDataError
        AddHandler dgv.EditingControlShowing, AddressOf OnGridEditingControlShowing

        Me.Controls.Add(dgv)
        Me.Controls.Add(topPanel)
        Me.Controls.Add(bottomPanel)
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
        If r.Table.Columns.Contains("MaterialID") AndAlso Not r.IsNull("MaterialID") Then
            Integer.TryParse(Convert.ToString(r("MaterialID")), id)
        End If

        If id > 0 Then
            ' Soft delete: deactivate
            If r.Table.Columns.Contains("IsActive") Then
                r("IsActive") = False
                MessageBox.Show("Row marked inactive. Click Save to persist.")
            End If
        Else
            ' New/unsaved: remove from table
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

    Private Sub OnGridEditingControlShowing(sender As Object, e As DataGridViewEditingControlShowingEventArgs)
        ' Enforce numeric input on cost and stock columns (allow decimals)
        UI.InputValidation.AttachNumericOnlyForGrid(dgv, e, True, "LastCost", "AverageCost", "CurrentStock")
    End Sub

    Private Sub LoadMaterials()
        Dim branchId As Integer = 0
        Try
            branchId = AppSession.CurrentBranchID
        Catch
            branchId = 0
        End Try
        Dim dt As DataTable = svc.GetAllMaterials(branchId)
        dgv.DataSource = dt
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Dim tbl = CType(dgv.DataSource, DataTable)
        Dim r = tbl.NewRow()
        r("MaterialCode") = ""
        r("MaterialName") = ""
        r("MaterialType") = "Raw"
        r("UnitOfMeasure") = "kg"
        r("IsActive") = True
        r("LastCost") = 0D
        r("AverageCost") = 0D
        r("CurrentStock") = 0D
        tbl.Rows.Add(r)
        ' Move focus to the new row and begin editing the Name cell
        Dim newIndex As Integer = dgv.Rows.Count - 1
        If newIndex >= 0 Then
            dgv.CurrentCell = dgv.Rows(newIndex).Cells("MaterialName")
            dgv.BeginEdit(True)
        End If
    End Sub

    ' Public helper so external menus can trigger an immediate add when the form opens
    Public Sub AddNewMaterialRow()
        OnAdd(Me, EventArgs.Empty)
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        dgv.EndEdit()
        Dim tbl = CType(dgv.DataSource, DataTable)
        svc.SaveMaterials(tbl)
        LoadMaterials()
        MessageBox.Show("Saved.")
    End Sub

    Private Sub OnGridDataError(sender As Object, e As DataGridViewDataErrorEventArgs)
        Try
            Dim colName As String = dgv.Columns(e.ColumnIndex).HeaderText
            MessageBox.Show($"Input error at row {e.RowIndex + 1}, column {colName}: {e.Exception.Message}")
            e.ThrowException = False
        Catch
            ' swallow
        End Try
    End Sub
    ' ISidebarProvider implementation
    Public Event SidebarContextChanged As EventHandler Implements UI.ISidebarProvider.SidebarContextChanged

    Public Function BuildSidebarPanel() As Panel Implements UI.ISidebarProvider.BuildSidebarPanel
        Dim panel As New Panel() With {
            .Dock = DockStyle.Fill
        }

        Dim btnAddSide As New Button() With {.Text = "Add Material", .Width = 180, .Height = 36}
        Dim btnSaveSide As New Button() With {.Text = "Save Changes", .Width = 180, .Height = 36}
        Dim btnRefreshSide As New Button() With {.Text = "Refresh", .Width = 180, .Height = 36}

        AddHandler btnAddSide.Click, Sub(s, e)
                                          OnAdd(s, e)
                                      End Sub
        AddHandler btnSaveSide.Click, Sub(s, e)
                                           OnSave(s, e)
                                       End Sub
        AddHandler btnRefreshSide.Click, Sub(s, e)
                                             LoadMaterials()
                                         End Sub

        Dim stack As New FlowLayoutPanel() With {
            .Dock = DockStyle.Top,
            .FlowDirection = FlowDirection.TopDown,
            .WrapContents = False,
            .Padding = New Padding(8),
            .AutoSize = True,
            .AutoSizeMode = AutoSizeMode.GrowAndShrink
        }
        stack.Controls.Add(btnAddSide)
        stack.Controls.Add(btnSaveSide)
        stack.Controls.Add(btnRefreshSide)

        panel.Controls.Add(stack)
        Return panel
    End Function

End Class
