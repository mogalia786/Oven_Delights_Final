Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing

    Public Class SubcomponentDialog
        Inherits Form

        Private cmbType As ComboBox
        Private cmbItem As ComboBox
        Private numQty As NumericUpDown
        Private cmbUoM As ComboBox
        Private txtFlavor As TextBox
        Private txtNotes As TextBox
        Private btnOk As Button
        Private btnCancel As Button

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private uomDt As DataTable

        Public ReadOnly Property SubcomponentDisplayName As String
            Get
                Dim t = If(cmbType.SelectedItem, "").ToString()
                Dim i = If(cmbItem.Text, "").ToString()
                Return $"{t}: {i}"
            End Get
        End Property

        Public Sub New()
            Me.Text = "Add Subcomponent"
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.StartPosition = FormStartPosition.CenterParent
            Me.MinimizeBox = False
            Me.MaximizeBox = False
            Me.Width = 540
            Me.Height = 280

            Dim y As Integer = 16
            Dim lblType As New Label() With {.Text = "Type:", .Left = 16, .Top = y, .AutoSize = True}
            cmbType = New ComboBox() With {.Left = 120, .Top = y - 3, .Width = 380, .DropDownStyle = ComboBoxStyle.DropDownList}
            cmbType.Items.AddRange(New Object() {"Raw Material", "SubAssembly", "Decoration", "Toppings", "Accessories", "Packaging"})
            AddHandler cmbType.SelectedIndexChanged, AddressOf OnTypeChanged

            y += 32
            Dim lblItem As New Label() With {.Text = "Item:", .Left = 16, .Top = y, .AutoSize = True}
            cmbItem = New ComboBox() With {.Left = 120, .Top = y - 3, .Width = 380}
            AddHandler cmbItem.SelectedIndexChanged, AddressOf OnItemChanged

            y += 32
            Dim lblQty As New Label() With {.Text = "Quantity:", .Left = 16, .Top = y, .AutoSize = True}
            numQty = New NumericUpDown() With {.Left = 120, .Top = y - 3, .Width = 120, .Minimum = 0, .Maximum = 1000000, .DecimalPlaces = 3, .Value = 0}

            Dim lblUoM As New Label() With {.Text = "UoM:", .Left = 260, .Top = y, .AutoSize = True}
            cmbUoM = New ComboBox() With {.Left = 300, .Top = y - 3, .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}

            y += 32
            Dim lblFlavor As New Label() With {.Text = "Flavor:", .Left = 16, .Top = y, .AutoSize = True}
            txtFlavor = New TextBox() With {.Left = 120, .Top = y - 3, .Width = 380}

            y += 32
            Dim lblNotes As New Label() With {.Text = "Notes:", .Left = 16, .Top = y, .AutoSize = True}
            txtNotes = New TextBox() With {.Left = 120, .Top = y - 3, .Width = 380}

            btnOk = New Button() With {.Text = "OK", .Left = 320, .Top = 210, .Width = 80}
            btnCancel = New Button() With {.Text = "Cancel", .Left = 410, .Top = 210, .Width = 80}
            AddHandler btnOk.Click, Sub()
                                        If cmbType.SelectedIndex < 0 OrElse String.IsNullOrWhiteSpace(cmbItem.Text) Then
                                            MessageBox.Show("Please select a type and item.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                            Return
                                        End If
                                        Me.DialogResult = DialogResult.OK
                                    End Sub
            AddHandler btnCancel.Click, Sub()
                                            Me.DialogResult = DialogResult.Cancel
                                        End Sub

            Me.Controls.AddRange(New Control() {lblType, cmbType, lblItem, cmbItem, lblQty, numQty, lblUoM, cmbUoM, lblFlavor, txtFlavor, lblNotes, txtNotes, btnOk, btnCancel})

            ' Load static lists
            Try
                LoadUoM()
            Catch
            End Try
        End Sub

        Public Function GetCreatedSubcomponentTag() As Object
            Dim bag As New Dictionary(Of String, Object)()
            bag("Type") = If(cmbType.SelectedItem, "").ToString()
            bag("Item") = cmbItem.Text
            bag("Qty") = numQty.Value
            bag("UoM") = cmbUoM.Text
            If cmbUoM.SelectedValue IsNot Nothing Then
                Dim uomId As Integer
                If Integer.TryParse(cmbUoM.SelectedValue.ToString(), uomId) Then
                    bag("UoMID") = uomId
                End If
            End If
            ' include IDs when applicable
            Dim selType = bag("Type").ToString()
            If selType = "Raw Material" Then
                If cmbItem.SelectedValue IsNot Nothing AndAlso Integer.TryParse(cmbItem.SelectedValue.ToString(), Nothing) Then
                    bag("MaterialID") = CInt(cmbItem.SelectedValue)
                End If
            ElseIf selType = "SubAssembly" Then
                If cmbItem.SelectedValue IsNot Nothing AndAlso Integer.TryParse(cmbItem.SelectedValue.ToString(), Nothing) Then
                    bag("SubAssemblyProductID") = CInt(cmbItem.SelectedValue)
                End If
            End If
            bag("Flavor") = txtFlavor.Text
            bag("Notes") = txtNotes.Text
            Return bag
        End Function

        Private Sub LoadUoM()
            uomDt = New DataTable()
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT UoMID, UoMCode FROM dbo.UoM ORDER BY UoMCode", cn)
                    uomDt.Load(cmd.ExecuteReader())
                End Using
            End Using
            cmbUoM.DisplayMember = "UoMCode"
            cmbUoM.ValueMember = "UoMID"
            cmbUoM.DataSource = uomDt
        End Sub

        Private Sub OnTypeChanged(sender As Object, e As EventArgs)
            Dim t = If(cmbType.SelectedItem, "").ToString()
            If t = "Raw Material" Then
                BindRawMaterials()
            ElseIf t = "SubAssembly" Then
                BindSubAssemblies()
            Else
                ' Free text for other types
                cmbItem.DataSource = Nothing
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
            End If
        End Sub

        Private Sub BindRawMaterials()
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Dim dt As New DataTable()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT m.MaterialID, (ISNULL(m.MaterialCode,'') + CASE WHEN ISNULL(m.MaterialCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(m.MaterialName,'')) AS Display, u.UoMID AS DefaultUoMID FROM dbo.RawMaterials m LEFT JOIN dbo.UoM u ON u.UoMCode = m.BaseUnit WHERE m.IsActive=1 ORDER BY m.MaterialName", cn)
                    dt.Load(cmd.ExecuteReader())
                End Using
                ' Clear previous binding first to avoid ValueMember validation against old schema
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "MaterialID"
                cmbItem.DataSource = dt
                cmbItem.DropDownStyle = ComboBoxStyle.DropDownList
            End Using
        End Sub

        Private Sub BindSubAssemblies()
            ' Show catalog of Sub-Assemblies
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Dim dt As New DataTable()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT s.SubAssemblyID, (ISNULL(s.SubAssemblyCode,'') + CASE WHEN ISNULL(s.SubAssemblyCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(s.SubAssemblyName,'')) AS Display, s.DefaultUoMID FROM dbo.SubAssemblies s WHERE ISNULL(s.IsActive,1)=1 ORDER BY s.SubAssemblyName", cn)
                    dt.Load(cmd.ExecuteReader())
                End Using
                ' Clear previous binding first to avoid ValueMember validation against old schema
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "SubAssemblyID"
                cmbItem.DataSource = dt
                cmbItem.DropDownStyle = ComboBoxStyle.DropDownList
            End Using
        End Sub

        Private Sub OnItemChanged(sender As Object, e As EventArgs)
            Dim t = If(cmbType.SelectedItem, "").ToString()
            If cmbItem.SelectedValue Is Nothing Then Return
            If t = "Raw Material" Then
                Dim drv = TryCast(cmbItem.SelectedItem, DataRowView)
                If drv IsNot Nothing AndAlso Not IsDBNull(drv("DefaultUoMID")) Then
                    cmbUoM.SelectedValue = CInt(drv("DefaultUoMID"))
                End If
            ElseIf t = "SubAssembly" Then
                Dim drv = TryCast(cmbItem.SelectedItem, DataRowView)
                If drv IsNot Nothing AndAlso Not IsDBNull(drv("DefaultUoMID")) Then
                    cmbUoM.SelectedValue = CInt(drv("DefaultUoMID"))
                End If
            End If
        End Sub

    End Class

End Namespace
