Imports System.Data
Imports System.Data.SqlClient

Public Class BOMInstanceForm
    Inherits Form

    Private cmbTemplate As ComboBox
    Private numBatchQty As NumericUpDown
    Private cmbBatchUoM As ComboBox

    Private numLength As NumericUpDown
    Private numWidth As NumericUpDown
    Private numHeight As NumericUpDown
    Private numDiameter As NumericUpDown
    Private numLayers As NumericUpDown

    Private dgvLines As DataGridView
    Private lblBatchCost As Label
    Private lblUnitCost As Label

    Private btnRecalculate As Button
    Private btnClose As Button

    Public Sub New()
        Me.Text = "BOM Instance (Production)"
        Me.Width = 1100
        Me.Height = 700
        InitializeUi()
    End Sub

    Private Sub InitializeUi()
        Dim y As Integer = 16
        Dim lblTemplate = New Label() With {.Text = "Template:", .Left = 20, .Top = y, .AutoSize = True}
        cmbTemplate = New ComboBox() With {.Left = 100, .Top = y - 3, .Width = 260, .DropDownStyle = ComboBoxStyle.DropDownList}

        Dim lblBatch = New Label() With {.Text = "Batch:", .Left = 380, .Top = y, .AutoSize = True}
        numBatchQty = New NumericUpDown() With {.Left = 430, .Top = y - 3, .Width = 100, .Minimum = 1, .Maximum = 100000, .DecimalPlaces = 2, .Value = 10}
        cmbBatchUoM = New ComboBox() With {.Left = 540, .Top = y - 3, .Width = 100, .DropDownStyle = ComboBoxStyle.DropDownList}

        y += 34
        Dim lblDims = New Label() With {.Text = "Dimensions (cm) & Layers:", .Left = 20, .Top = y, .AutoSize = True}
        y += 24
        numLength = New NumericUpDown() With {.Left = 20, .Top = y, .Width = 80, .DecimalPlaces = 2, .Minimum = 0, .Maximum = 1000}
        Dim lblL = New Label() With {.Text = "Length", .Left = 20, .Top = y + 26, .AutoSize = True}
        numWidth = New NumericUpDown() With {.Left = 110, .Top = y, .Width = 80, .DecimalPlaces = 2, .Minimum = 0, .Maximum = 1000}
        Dim lblW = New Label() With {.Text = "Width", .Left = 110, .Top = y + 26, .AutoSize = True}
        numHeight = New NumericUpDown() With {.Left = 200, .Top = y, .Width = 80, .DecimalPlaces = 2, .Minimum = 0, .Maximum = 1000}
        Dim lblH = New Label() With {.Text = "Height", .Left = 200, .Top = y + 26, .AutoSize = True}
        numDiameter = New NumericUpDown() With {.Left = 290, .Top = y, .Width = 80, .DecimalPlaces = 2, .Minimum = 0, .Maximum = 1000}
        Dim lblD = New Label() With {.Text = "Diameter", .Left = 290, .Top = y + 26, .AutoSize = True}
        numLayers = New NumericUpDown() With {.Left = 380, .Top = y, .Width = 80, .Minimum = 0, .Maximum = 50}
        Dim lblLayers = New Label() With {.Text = "Layers", .Left = 380, .Top = y + 26, .AutoSize = True}

        dgvLines = New DataGridView() With {
            .Left = 20, .Top = y + 50, .Width = 1040, .Height = 470,
            .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False, .AutoGenerateColumns = False,
            .Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
        }
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Line", .Name = "LineNo", .Width = 50})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Component", .Name = "Component", .Width = 260})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Qty", .Name = "Qty", .Width = 100})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "UoM", .Name = "UoM", .Width = 80})
        dgvLines.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Optional", .Name = "IsOptional", .Width = 70})
        dgvLines.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Include", .Name = "Include", .Width = 70})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Notes", .Name = "Notes", .AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill})

        btnRecalculate = New Button() With {.Text = "Recalculate", .Left = 20, .Top = 600, .Width = 110}
        btnClose = New Button() With {.Text = "Close", .Left = 950, .Top = 600, .Width = 110, .Anchor = AnchorStyles.Bottom Or AnchorStyles.Right}
        AddHandler btnClose.Click, Sub(s, e) Me.Close()

        lblBatchCost = New Label() With {.Text = "Batch Cost: 0.00", .Left = 560, .Top = 600, .AutoSize = True}
        lblUnitCost = New Label() With {.Text = "Per-Unit Cost: 0.00", .Left = 560, .Top = 622, .AutoSize = True}

        Me.Controls.AddRange(New Control() {lblTemplate, cmbTemplate, lblBatch, numBatchQty, cmbBatchUoM,
                                            lblDims, numLength, lblL, numWidth, lblW, numHeight, lblH, numDiameter, lblD, numLayers, lblLayers,
                                            dgvLines, btnRecalculate, btnClose, lblBatchCost, lblUnitCost})
    End Sub
End Class
