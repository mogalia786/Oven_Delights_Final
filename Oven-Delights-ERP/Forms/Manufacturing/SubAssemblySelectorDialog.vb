Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class SubAssemblySelectorDialog
        Inherits Form

        Private dgvProducts As DataGridView
        Private txtSearch As TextBox
        Private btnSelect As Button
        Private btnCancel As Button

        Public Property SelectedProductID As Integer
        Public Property SelectedSKU As String
        Public Property SelectedName As String

        Public Sub New()
            InitializeComponent()
            LoadProducts()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Select Sub-Assembly"
            Me.Size = New Size(800, 600)
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
                .Size = New Size(680, 25)
            }

            dgvProducts = New DataGridView With {
                .Location = New Point(20, 60),
                .Size = New Size(750, 450),
                .BackgroundColor = Color.White,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .ReadOnly = True,
                .AllowUserToAddRows = False,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            }

            btnSelect = New Button With {
                .Text = "Select",
                .Location = New Point(590, 520),
                .Size = New Size(90, 30),
                .DialogResult = DialogResult.OK
            }

            btnCancel = New Button With {
                .Text = "Cancel",
                .Location = New Point(690, 520),
                .Size = New Size(80, 30),
                .DialogResult = DialogResult.Cancel
            }

            Controls.AddRange({lblSearch, txtSearch, dgvProducts, btnSelect, btnCancel})

            AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged
            AddHandler dgvProducts.CellDoubleClick, AddressOf OnCellDoubleClick
            AddHandler btnSelect.Click, AddressOf OnSelect
        End Sub

        Private Sub LoadProducts(Optional searchText As String = "")
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql = "SELECT ProductID, SKU, Name, Category FROM dbo.Demo_Retail_Product WHERE ProductType = 'Internal' AND ISNULL(IsActive, 1) = 1"
                    If Not String.IsNullOrEmpty(searchText) Then
                        sql &= " AND (SKU LIKE @search OR Name LIKE @search)"
                    End If
                    sql &= " ORDER BY Name"

                    Using cmd As New SqlCommand(sql, cn)
                        If Not String.IsNullOrEmpty(searchText) Then
                            cmd.Parameters.AddWithValue("@search", "%" & searchText & "%")
                        End If
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            dgvProducts.DataSource = dt
                            dgvProducts.Columns("ProductID").Visible = False
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnSearchChanged(sender As Object, e As EventArgs)
            LoadProducts(txtSearch.Text)
        End Sub

        Private Sub OnCellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex >= 0 Then
                OnSelect(Nothing, Nothing)
            End If
        End Sub

        Private Sub OnSelect(sender As Object, e As EventArgs)
            If dgvProducts.SelectedRows.Count > 0 Then
                Dim row = dgvProducts.SelectedRows(0)
                SelectedProductID = CInt(row.Cells("ProductID").Value)
                SelectedSKU = row.Cells("SKU").Value.ToString()
                SelectedName = row.Cells("Name").Value.ToString()
                Me.DialogResult = DialogResult.OK
                Me.Close()
            End If
        End Sub
    End Class
End Namespace
