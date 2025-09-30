Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms

Namespace UI
Public Module ProductDropdown
    Private _allProducts As DataTable
    Private _loaded As Boolean = False

    Private Sub EnsureLoaded()
        If _loaded AndAlso _allProducts IsNot Nothing AndAlso _allProducts.Rows.Count > 0 Then Return
        _allProducts = New DataTable()
        Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(cs) Then
            _loaded = True : Return
        End If
        ' Try multiple sources to cope with different DB schemas
        Dim tried As Boolean = False
        ' 1) Preferred view
        Try
            Using cn As New SqlConnection(cs)
                Using da As New SqlDataAdapter("SELECT ProductID, SKU, Name FROM dbo.v_Retail_ProductCatalog WITH (NOLOCK) ORDER BY Name", cn)
                    da.Fill(_allProducts)
                    tried = True
                End Using
            End Using
        Catch
        End Try
        ' 2) Retail_Product table
        If _allProducts.Rows.Count = 0 Then
            Try
                Using cn As New SqlConnection(cs)
                    Using da As New SqlDataAdapter("SELECT ProductID, SKU, Name FROM dbo.Retail_Product WITH (NOLOCK) ORDER BY Name", cn)
                        If Not tried Then tried = True
                        da.Fill(_allProducts)
                    End Using
                End Using
            Catch
            End Try
        End If
        ' 3) Generic Products table mapping
        If _allProducts.Rows.Count = 0 Then
            Try
                Using cn As New SqlConnection(cs)
                    Using da As New SqlDataAdapter("SELECT ProductID, ProductCode AS SKU, ProductName AS Name FROM dbo.Products WITH (NOLOCK) ORDER BY ProductName", cn)
                        da.Fill(_allProducts)
                    End Using
                End Using
            Catch
            End Try
        End If
        _loaded = True
    End Sub

    Public Sub Reload()
        _loaded = False
        If _allProducts IsNot Nothing Then _allProducts.Dispose()
        _allProducts = Nothing
        EnsureLoaded()
    End Sub

    ' Creates and attaches a searchable ComboBox for products next to an existing SKU TextBox.
    ' Returns the ComboBox. SelectedValue = SKU string.
    Public Function Create(target As Form, anchorSkuTextBox As TextBox) As ComboBox
        EnsureLoaded()
        Dim cb As New ComboBox()
        cb.Name = "cboProductPicker"
        cb.DropDownStyle = ComboBoxStyle.DropDownList
        ' Cap width so it doesn't cover the whole screen
        Dim baseWidth = If(anchorSkuTextBox IsNot Nothing, anchorSkuTextBox.Width, 240)
        cb.Width = Math.Min(Math.Max(260, baseWidth), 380)
        If anchorSkuTextBox IsNot Nothing Then
            cb.Left = anchorSkuTextBox.Left
            cb.Top = anchorSkuTextBox.Top
            ' Prevent stretching across the entire form
            cb.Anchor = AnchorStyles.Top Or AnchorStyles.Left
        Else
            cb.Left = 12
            cb.Top = 12
            cb.Anchor = AnchorStyles.Top Or AnchorStyles.Left
        End If
        target.Controls.Add(cb)

        ' Build binding table with a friendly Display
        Dim bind As DataTable = _allProducts.Copy()
        If Not bind.Columns.Contains("Display") Then bind.Columns.Add("Display", GetType(String))
        For Each r As DataRow In bind.Rows
            Dim sku = Convert.ToString(r("SKU"))
            Dim name = Convert.ToString(r("Name"))
            r("Display") = If(String.IsNullOrWhiteSpace(name), sku, $"{name} [{sku}]")
        Next

        Dim view As New DataView(bind)
        cb.DataSource = view
        cb.DisplayMember = "Display"
        cb.ValueMember = "SKU"

        ' Live filter on typing using a separate editable TextBox overlay
        ' Change DropDownStyle to DropDown to allow typing
        cb.DropDownStyle = ComboBoxStyle.DropDown
        AddHandler cb.TextChanged, Sub()
                                       Dim q = cb.Text.Trim().Replace("'", "''")
                                       If q.Length = 0 Then
                                           view.RowFilter = ""
                                       Else
                                           ' Filter by product name (and friendly display), not by SKU
                                           view.RowFilter = $"Name LIKE '%{q}%' OR Display LIKE '%{q}%'"
                                       End If
                                   End Sub

        ' Update anchor text box if provided
        If anchorSkuTextBox IsNot Nothing Then
            Try
                anchorSkuTextBox.Visible = False
            Catch
            End Try
            AddHandler cb.SelectedValueChanged, Sub()
                                                    Dim v = TryCast(cb.SelectedValue, String)
                                                    If v IsNot Nothing Then anchorSkuTextBox.Text = v
                                                End Sub
        End If

        Return cb
    End Function
End Module
End Namespace
