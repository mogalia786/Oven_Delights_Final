Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class RawMaterialSelectorDialog
        Inherits Form

        Private dgvMaterials As DataGridView
        Private txtSearch As TextBox
        Private btnSelect As Button
        Private btnCancel As Button

        Public Property SelectedMaterialID As Integer
        Public Property SelectedMaterialCode As String
        Public Property SelectedMaterialName As String
        Public Property SelectedUoM As String
        Public Property SelectedType As String  ' 'Raw Material' or 'Sub Recipe'

        Public Sub New()
            InitializeComponent()
            LoadMaterials()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Select Component"
            Me.Size = New Size(900, 600)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            Dim lblSearch As New Label With {
                .Text = "Search:",
                .Location = New Point(20, 20),
                .Size = New Size(60, 25)
            }

            txtSearch = New TextBox With {
                .Location = New Point(90, 18),
                .Size = New Size(780, 25)
            }

            dgvMaterials = New DataGridView With {
                .Location = New Point(20, 60),
                .Size = New Size(850, 450),
                .BackgroundColor = Color.White,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .ReadOnly = True,
                .AllowUserToAddRows = False,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            }

            btnSelect = New Button With {
                .Text = "Select",
                .Location = New Point(690, 520),
                .Size = New Size(90, 30),
                .DialogResult = DialogResult.OK
            }

            btnCancel = New Button With {
                .Text = "Cancel",
                .Location = New Point(790, 520),
                .Size = New Size(80, 30),
                .DialogResult = DialogResult.Cancel
            }

            Controls.AddRange({lblSearch, txtSearch, dgvMaterials, btnSelect, btnCancel})

            AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged
            AddHandler dgvMaterials.CellDoubleClick, AddressOf OnCellDoubleClick
            AddHandler btnSelect.Click, AddressOf OnSelect
        End Sub

        Private Sub LoadMaterials(Optional searchText As String = "")
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    
                    ' Get current branch prefix (e.g., 'AC' for Ayesha Centre, 'UM' for Umhlanga)
                    Dim branchPrefix As String = ""
                    Dim currentBranchId As Integer = AppSession.CurrentBranchID
                    If currentBranchId > 0 Then
                        Using cmdPrefix As New SqlCommand("SELECT Prefix FROM Branches WHERE BranchID = @bid", cn)
                            cmdPrefix.Parameters.AddWithValue("@bid", currentBranchId)
                            Dim prefixResult = cmdPrefix.ExecuteScalar()
                            If prefixResult IsNot Nothing AndAlso Not IsDBNull(prefixResult) Then
                                branchPrefix = Convert.ToString(prefixResult).Trim().ToUpper()
                            End If
                        End Using
                    End If
                    
                    ' MaterialCode format: PREFIX-DESCRIPTION-UNIT (e.g., ACXTO-ALE-KGR, ACYBB-BDO-MX1)
                    ' First 2 letters = branch prefix (AC, UM)
                    ' Last 3 letters = unit/pack size (KGR, EAC, MX1, MX6, MX12)
                    ' MaterialType = 'Raw' or 'Sub Recipe'
                    Dim sql = "SELECT MaterialID AS ID, MaterialCode AS Code, MaterialName AS Name, MaterialType AS Type, " &
                             "RIGHT(MaterialCode, 3) AS UoMCode " &
                             "FROM dbo.RawMaterials WHERE IsActive = 1"
                    
                    ' Filter by branch prefix (first 2 letters)
                    If Not String.IsNullOrEmpty(branchPrefix) Then
                        sql &= " AND LEFT(MaterialCode, 2) = @prefix"
                    End If
                    
                    ' Filter by search text
                    If Not String.IsNullOrEmpty(searchText) Then
                        sql &= " AND (MaterialCode LIKE @search OR MaterialName LIKE @search)"
                    End If
                    
                    sql &= " ORDER BY MaterialName"

                    Using cmd As New SqlCommand(sql, cn)
                        If Not String.IsNullOrEmpty(branchPrefix) Then
                            cmd.Parameters.AddWithValue("@prefix", branchPrefix)
                        End If
                        If Not String.IsNullOrEmpty(searchText) Then
                            cmd.Parameters.AddWithValue("@search", "%" & searchText & "%")
                        End If
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            dgvMaterials.DataSource = dt
                            dgvMaterials.Columns("ID").Visible = False
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading materials: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnSearchChanged(sender As Object, e As EventArgs)
            LoadMaterials(txtSearch.Text)
        End Sub

        Private Sub OnCellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex >= 0 Then
                OnSelect(Nothing, Nothing)
            End If
        End Sub

        Private Sub OnSelect(sender As Object, e As EventArgs)
            If dgvMaterials.SelectedRows.Count > 0 Then
                Dim row = dgvMaterials.SelectedRows(0)
                SelectedMaterialID = CInt(row.Cells("ID").Value)
                SelectedMaterialCode = row.Cells("Code").Value.ToString()
                SelectedMaterialName = row.Cells("Name").Value.ToString()
                SelectedUoM = row.Cells("UoMCode").Value.ToString()
                SelectedType = row.Cells("Type").Value.ToString()  ' 'Raw Material' or 'Sub Recipe'
                Me.DialogResult = DialogResult.OK
                Me.Close()
            End If
        End Sub
    End Class
End Namespace
