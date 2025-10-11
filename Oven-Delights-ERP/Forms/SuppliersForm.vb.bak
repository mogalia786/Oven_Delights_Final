Imports System.Data
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Public Class SuppliersForm
    Inherits Form

    Private ReadOnly svc As New StockroomService()

    Private dgv As DataGridView
    Private btnAdd As Button
    Private btnSave As Button
    Private btnClose As Button

    Public Sub New()
        Me.Text = "Suppliers"
        Me.Width = 900
        Me.Height = 600
        InitializeComponent()
        Theme.Apply(Me)
        Theme.StylePrimaryButton(btnAdd)
        Theme.StyleSecondaryButton(btnSave)
        Theme.StyleSecondaryButton(btnClose)
        Theme.StyleGrid(dgv)
        LoadSuppliers()
    End Sub

    Private Sub InitializeComponent()
        dgv = New DataGridView() With { .Dock = DockStyle.Fill, .AutoGenerateColumns = False, .AllowUserToAddRows = False }
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "ID", .DataPropertyName = "ID", .Name = "ID", .Visible = False})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Supplier Code", .DataPropertyName = "SupplierCode", .Name = "SupplierCode", .Width = 150})
        dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Company Name", .DataPropertyName = "Name", .Name = "Name", .Width = 400})
        dgv.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Active", .DataPropertyName = "IsActive", .Name = "IsActive", .Width = 80})

        btnAdd = New Button() With {.Text = "Add New", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnSave = New Button() With {.Text = "Save", .Height = 34, .Dock = DockStyle.Left, .Width = 120}
        btnClose = New Button() With {.Text = "Close", .Height = 34, .Dock = DockStyle.Left, .Width = 120}

        Dim topPanel As New FlowLayoutPanel() With {.Dock = DockStyle.Top, .Height = 44, .Padding = New Padding(8)}
        topPanel.Controls.AddRange(New Control() {btnAdd, btnSave, btnClose})

        AddHandler btnAdd.Click, AddressOf OnAdd
        AddHandler btnSave.Click, AddressOf OnSave
        AddHandler btnClose.Click, Sub(sender, e) Me.Close()

        Me.Controls.Add(dgv)
        Me.Controls.Add(topPanel)
    End Sub

    Private Sub LoadSuppliers()
        Dim dt As DataTable = svc.GetAllSuppliers()
        If Not dt.Columns.Contains("IsActive") Then dt.Columns.Add("IsActive", GetType(Boolean))
        dgv.DataSource = dt
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Dim tbl = CType(dgv.DataSource, DataTable)
        Dim r = tbl.NewRow()
        r("SupplierCode") = ""
        r("Name") = ""
        r("IsActive") = True
        tbl.Rows.Add(r)
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        dgv.EndEdit()
        Dim tbl = CType(dgv.DataSource, DataTable)
        svc.SaveSuppliers(tbl)
        LoadSuppliers()
        MessageBox.Show("Saved.")
    End Sub
End Class
