Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing

Public Class ComponentDialog
    Inherits Form

    Private rbExisting As RadioButton
    Private rbNew As RadioButton
    Private cmbExisting As ComboBox
    Private txtName As TextBox
    Private btnOk As Button
    Private btnCancel As Button

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private compsDt As DataTable
    Private _selectedComponentId As Integer = 0

    Public ReadOnly Property ComponentDisplayName As String
        Get
            Return txtName.Text.Trim()
        End Get
    End Property

    Public Sub New()
        Me.Text = "Add Component"
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.StartPosition = FormStartPosition.CenterParent
        Me.MinimizeBox = False
        Me.MaximizeBox = False
        Me.Width = 520
        Me.Height = 220

        rbExisting = New RadioButton() With {.Text = "Existing", .Left = 16, .Top = 16, .AutoSize = True, .Checked = True}
        rbNew = New RadioButton() With {.Text = "New", .Left = 110, .Top = 16, .AutoSize = True}
        AddHandler rbExisting.CheckedChanged, AddressOf ToggleMode
        AddHandler rbNew.CheckedChanged, AddressOf ToggleMode

        Dim lblExisting As New Label() With {.Text = "Component:", .Left = 16, .Top = 48, .AutoSize = True}
        cmbExisting = New ComboBox() With {.Left = 100, .Top = 44, .Width = 390, .DropDownStyle = ComboBoxStyle.DropDownList}

        Dim lblNew As New Label() With {.Text = "Name:", .Left = 16, .Top = 82, .AutoSize = True}
        txtName = New TextBox() With {.Left = 100, .Top = 78, .Width = 390, .Enabled = False}

        btnOk = New Button() With {.Text = "OK", .Left = 330, .Top = 130, .Width = 80}
        btnCancel = New Button() With {.Text = "Cancel", .Left = 420, .Top = 130, .Width = 80}
        AddHandler btnOk.Click, AddressOf OnOk
        AddHandler btnCancel.Click, Sub() Me.DialogResult = DialogResult.Cancel

        Me.Controls.AddRange(New Control() {rbExisting, rbNew, lblExisting, cmbExisting, lblNew, txtName, btnOk, btnCancel})

        ' Load existing components
        Try
            LoadComponents()
        Catch
        End Try
    End Sub

    Private Sub ToggleMode(sender As Object, e As EventArgs)
        Dim isExisting = rbExisting.Checked
        cmbExisting.Enabled = isExisting
        txtName.Enabled = Not isExisting
    End Sub

    Private Sub LoadComponents()
        compsDt = New DataTable()
        Using cn As New SqlConnection(_connectionString)
            cn.Open()
            Using cmd As New SqlCommand("SELECT ComponentID, ComponentName FROM dbo.ComponentDefinition WHERE ISNULL(IsActive,1)=1 ORDER BY ComponentName", cn)
                compsDt.Load(cmd.ExecuteReader())
            End Using
        End Using
        cmbExisting.DisplayMember = "ComponentName"
        cmbExisting.ValueMember = "ComponentID"
        cmbExisting.DataSource = compsDt
    End Sub

    Private Sub OnOk(sender As Object, e As EventArgs)
        If rbExisting.Checked Then
            If cmbExisting.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a component.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Integer.TryParse(cmbExisting.SelectedValue.ToString(), _selectedComponentId)
            txtName.Text = cmbExisting.Text
        Else
            If String.IsNullOrWhiteSpace(txtName.Text) Then
                MessageBox.Show("Please enter a component name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Try
                _selectedComponentId = EnsureComponentExists(txtName.Text.Trim())
            Catch ex As Exception
                MessageBox.Show("Failed to save component: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End Try
        End If
        Me.DialogResult = DialogResult.OK
    End Sub

    Public Function GetCreatedComponentTag() As Object
        Dim bag As New Dictionary(Of String, Object)()
        bag("Type") = "Component"
        bag("Name") = Me.ComponentDisplayName
        If _selectedComponentId > 0 Then
            bag("ComponentDefinitionID") = _selectedComponentId
        End If
        Return bag
    End Function

    Private Function EnsureComponentExists(name As String) As Integer
        Using cn As New SqlConnection(_connectionString)
            cn.Open()
            Using cmd As New SqlCommand("IF EXISTS (SELECT 1 FROM dbo.ComponentDefinition WHERE ComponentName = @n) SELECT ComponentID FROM dbo.ComponentDefinition WHERE ComponentName=@n ELSE BEGIN INSERT INTO dbo.ComponentDefinition (ComponentName, IsActive) VALUES (@n, 1); SELECT SCOPE_IDENTITY(); END", cn)
                cmd.Parameters.AddWithValue("@n", name)
                Dim obj = cmd.ExecuteScalar()
                Return Convert.ToInt32(obj)
            End Using
        End Using
    End Function

End Class

End Namespace
