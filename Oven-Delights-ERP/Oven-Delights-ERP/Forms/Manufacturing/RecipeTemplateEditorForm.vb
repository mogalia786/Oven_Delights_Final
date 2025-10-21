Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class RecipeTemplateEditorForm
    Inherits Form

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private cmbCategory As ComboBox
    Private cmbSubcategory As ComboBox
    Private txtTemplateName As TextBox
    Private numYield As NumericUpDown
    Private cmbYieldUoM As ComboBox

    Private chkUseLength As CheckBox
    Private chkUseWidth As CheckBox
    Private chkUseHeight As CheckBox
    Private chkUseDiameter As CheckBox
    Private chkUseLayers As CheckBox

    Private dgvComponents As DataGridView

    Private btnAddLine As Button
    Private btnRemoveLine As Button
    Private btnSave As Button
    Private btnClose As Button

    Public Sub New()
        Me.Text = "Recipe Template Editor"
        Me.Width = 1100
        Me.Height = 700
        InitializeUi()
    End Sub

    Private Sub InitializeUi()
        Dim lblCategory = New Label() With {.Text = "Category:", .Left = 20, .Top = 20, .AutoSize = True}
        cmbCategory = New ComboBox() With {.Left = 120, .Top = 16, .Width = 220, .DropDownStyle = ComboBoxStyle.DropDownList}

        Dim lblSubcategory = New Label() With {.Text = "Subcategory:", .Left = 360, .Top = 20, .AutoSize = True}
        cmbSubcategory = New ComboBox() With {.Left = 470, .Top = 16, .Width = 220, .DropDownStyle = ComboBoxStyle.DropDownList}

        Dim lblTemplate = New Label() With {.Text = "Template:", .Left = 20, .Top = 55, .AutoSize = True}
        txtTemplateName = New TextBox() With {.Left = 120, .Top = 52, .Width = 220}

        Dim lblYield = New Label() With {.Text = "Default Yield:", .Left = 360, .Top = 55, .AutoSize = True}
        numYield = New NumericUpDown() With {.Left = 470, .Top = 52, .Width = 100, .Minimum = 1, .Maximum = 100000, .DecimalPlaces = 2, .Value = 1}
        cmbYieldUoM = New ComboBox() With {.Left = 580, .Top = 52, .Width = 110, .DropDownStyle = ComboBoxStyle.DropDownList}

        chkUseLength = New CheckBox() With {.Text = "Length", .Left = 20, .Top = 90, .AutoSize = True, .Checked = True}
        chkUseWidth = New CheckBox() With {.Text = "Width", .Left = 100, .Top = 90, .AutoSize = True, .Checked = True}
        chkUseHeight = New CheckBox() With {.Text = "Height", .Left = 180, .Top = 90, .AutoSize = True}
        chkUseDiameter = New CheckBox() With {.Text = "Diameter", .Left = 260, .Top = 90, .AutoSize = True}
        chkUseLayers = New CheckBox() With {.Text = "Layers", .Left = 360, .Top = 90, .AutoSize = True}

        dgvComponents = New DataGridView() With {
            .Left = 20, .Top = 130, .Width = 1040, .Height = 460,
            .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False, .AutoGenerateColumns = False,
            .Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
        }

        ' Columns
        dgvComponents.Columns.Add(New DataGridViewComboBoxColumn() With {.HeaderText = "Type", .Name = "ComponentType", .DataPropertyName = "ComponentType", .Width = 110})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Material/SubAsm", .Name = "ComponentRef", .DataPropertyName = "ComponentRef", .Width = 220})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Base Qty", .Name = "BaseQty", .DataPropertyName = "BaseQty", .Width = 90})
        dgvComponents.Columns.Add(New DataGridViewComboBoxColumn() With {.HeaderText = "UoM", .Name = "UoM", .DataPropertyName = "UoM", .Width = 90})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Scrap %", .Name = "Scrap", .DataPropertyName = "ScrapPercent", .Width = 80})
        dgvComponents.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Optional", .Name = "IsOptional", .DataPropertyName = "IsOptional", .Width = 70})
        dgvComponents.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Std Cost", .Name = "IncludeInStandardCost", .DataPropertyName = "IncludeInStandardCost", .Width = 70})
        dgvComponents.Columns.Add(New DataGridViewComboBoxColumn() With {.HeaderText = "Scaling", .Name = "ScalingRule", .DataPropertyName = "ScalingRule", .Width = 120})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Notes", .Name = "Notes", .DataPropertyName = "Notes", .AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill})

        btnAddLine = New Button() With {.Text = "Add Line", .Left = 20, .Top = 600, .Width = 100}
        btnRemoveLine = New Button() With {.Text = "Remove", .Left = 130, .Top = 600, .Width = 100}
        btnSave = New Button() With {.Text = "Save", .Left = 870, .Top = 600, .Width = 90, .Anchor = AnchorStyles.Bottom Or AnchorStyles.Right}
        btnClose = New Button() With {.Text = "Close", .Left = 970, .Top = 600, .Width = 90, .Anchor = AnchorStyles.Bottom Or AnchorStyles.Right}

        AddHandler btnClose.Click, Sub(sender, e) Me.Close()

        Me.Controls.AddRange(New Control() {lblCategory, cmbCategory, lblSubcategory, cmbSubcategory, lblTemplate, txtTemplateName, lblYield, numYield, cmbYieldUoM,
                                            chkUseLength, chkUseWidth, chkUseHeight, chkUseDiameter, chkUseLayers,
                                            dgvComponents, btnAddLine, btnRemoveLine, btnSave, btnClose})
    End Sub
End Class
