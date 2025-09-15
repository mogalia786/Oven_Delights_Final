Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class CategorySubcategorySelector
    Inherits UserControl

    Private ReadOnly _connString As String
    Private _selectedCategoryID As Integer?
    Private _selectedSubcategoryID As Integer?

    ' Events
    Public Event SelectionChanged(sender As Object, e As EventArgs)

    ' Properties
    Public ReadOnly Property SelectedCategoryID As Integer?
        Get
            Return _selectedCategoryID
        End Get
    End Property

    Public ReadOnly Property SelectedSubcategoryID As Integer?
        Get
            Return _selectedSubcategoryID
        End Get
    End Property

    Public ReadOnly Property SelectedCategoryName As String
        Get
            If cboCategory.SelectedItem IsNot Nothing Then
                Return DirectCast(cboCategory.SelectedItem, DataRowView)("CategoryName").ToString()
            End If
            Return String.Empty
        End Get
    End Property

    Public ReadOnly Property SelectedSubcategoryName As String
        Get
            If cboSubcategory.SelectedItem IsNot Nothing Then
                Return DirectCast(cboSubcategory.SelectedItem, DataRowView)("SubcategoryName").ToString()
            End If
            Return String.Empty
        End Get
    End Property

    Public ReadOnly Property IsValidSelection As Boolean
        Get
            Return _selectedCategoryID.HasValue AndAlso _selectedSubcategoryID.HasValue AndAlso
                   SelectedCategoryName <> "Uncategorized" AndAlso SelectedSubcategoryName <> "General"
        End Get
    End Property

    ' Controls
    Private WithEvents cboCategory As ComboBox
    Private WithEvents cboSubcategory As ComboBox
    Private lblCategory As Label
    Private lblSubcategory As Label
    Private lblValidation As Label

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        LoadCategories()
    End Sub

    Private Sub InitializeComponent()
        Me.Size = New Size(400, 120)

        ' Category Label
        lblCategory = New Label()
        lblCategory.Text = "Category:"
        lblCategory.Location = New Point(5, 10)
        lblCategory.Size = New Size(80, 20)
        Me.Controls.Add(lblCategory)

        ' Category ComboBox
        cboCategory = New ComboBox()
        cboCategory.Location = New Point(90, 8)
        cboCategory.Size = New Size(300, 25)
        cboCategory.DropDownStyle = ComboBoxStyle.DropDownList
        Me.Controls.Add(cboCategory)

        ' Subcategory Label
        lblSubcategory = New Label()
        lblSubcategory.Text = "Subcategory:"
        lblSubcategory.Location = New Point(5, 45)
        lblSubcategory.Size = New Size(80, 20)
        Me.Controls.Add(lblSubcategory)

        ' Subcategory ComboBox
        cboSubcategory = New ComboBox()
        cboSubcategory.Location = New Point(90, 43)
        cboSubcategory.Size = New Size(300, 25)
        cboSubcategory.DropDownStyle = ComboBoxStyle.DropDownList
        cboSubcategory.Enabled = False
        Me.Controls.Add(cboSubcategory)

        ' Validation Label
        lblValidation = New Label()
        lblValidation.Location = New Point(5, 75)
        lblValidation.Size = New Size(385, 40)
        lblValidation.ForeColor = Color.Red
        lblValidation.Font = New Font(lblValidation.Font, FontStyle.Bold)
        lblValidation.Text = "⚠️ Please select Category and Subcategory - Product cannot be saved without proper classification"
        Me.Controls.Add(lblValidation)
    End Sub

    Private Sub LoadCategories()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim cmd As New SqlCommand("SELECT CategoryID, CategoryName FROM dbo.ProductCategories WHERE IsActive = 1 ORDER BY CategoryName", conn)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Add default option
                Dim defaultRow As DataRow = dt.NewRow()
                defaultRow("CategoryID") = DBNull.Value
                defaultRow("CategoryName") = "-- Select Category --"
                dt.Rows.InsertAt(defaultRow, 0)

                cboCategory.DataSource = dt
                cboCategory.DisplayMember = "CategoryName"
                cboCategory.ValueMember = "CategoryID"
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadSubcategories(categoryID As Integer)
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SubcategoryID, SubcategoryName FROM dbo.ProductSubcategories WHERE CategoryID = @CategoryID AND IsActive = 1 ORDER BY SubcategoryName", conn)
                cmd.Parameters.AddWithValue("@CategoryID", categoryID)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                ' Add default option
                Dim defaultRow As DataRow = dt.NewRow()
                defaultRow("SubcategoryID") = DBNull.Value
                defaultRow("SubcategoryName") = "-- Select Subcategory --"
                dt.Rows.InsertAt(defaultRow, 0)

                cboSubcategory.DataSource = dt
                cboSubcategory.DisplayMember = "SubcategoryName"
                cboSubcategory.ValueMember = "SubcategoryID"
                cboSubcategory.Enabled = True
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading subcategories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboCategory_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboCategory.SelectedIndexChanged
        Try
            If cboCategory.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboCategory.SelectedValue) Then
                _selectedCategoryID = Convert.ToInt32(cboCategory.SelectedValue)
                LoadSubcategories(_selectedCategoryID.Value)
            Else
                _selectedCategoryID = Nothing
                cboSubcategory.DataSource = Nothing
                cboSubcategory.Enabled = False
            End If
        Catch ex As InvalidCastException
            ' Handle DBNull casting specifically
            _selectedCategoryID = Nothing
            cboSubcategory.DataSource = Nothing
            cboSubcategory.Enabled = False
        Catch ex As Exception
            ' Handle any other conversion errors
            _selectedCategoryID = Nothing
            cboSubcategory.DataSource = Nothing
            cboSubcategory.Enabled = False
        End Try

        _selectedSubcategoryID = Nothing
        UpdateValidationMessage()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub cboSubcategory_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSubcategory.SelectedIndexChanged
        Try
            If cboSubcategory.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboSubcategory.SelectedValue) Then
                _selectedSubcategoryID = Convert.ToInt32(cboSubcategory.SelectedValue)
            Else
                _selectedSubcategoryID = Nothing
            End If
        Catch ex As InvalidCastException
            ' Handle DBNull casting specifically
            _selectedSubcategoryID = Nothing
        Catch ex As Exception
            ' Handle any other conversion errors
            _selectedSubcategoryID = Nothing
        End Try

        UpdateValidationMessage()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub UpdateValidationMessage()
        If IsValidSelection Then
            lblValidation.Text = "✅ Valid classification selected"
            lblValidation.ForeColor = Color.Green
        ElseIf SelectedCategoryName = "Uncategorized" OrElse SelectedSubcategoryName = "General" Then
            lblValidation.Text = "⚠️ Cannot use 'Uncategorized' or 'General' - Please select proper classification"
            lblValidation.ForeColor = Color.Red
        Else
            lblValidation.Text = "⚠️ Please select Category and Subcategory - Product cannot be saved without proper classification"
            lblValidation.ForeColor = Color.Red
        End If
    End Sub

    Public Sub SetSelection(categoryName As String, subcategoryName As String)
        ' Set category
        For i As Integer = 0 To cboCategory.Items.Count - 1
            Dim row As DataRowView = DirectCast(cboCategory.Items(i), DataRowView)
            If row("CategoryName").ToString() = categoryName Then
                cboCategory.SelectedIndex = i
                Exit For
            End If
        Next

        ' Set subcategory (after category loads subcategories)
        If cboSubcategory.Items IsNot Nothing Then
            For i As Integer = 0 To cboSubcategory.Items.Count - 1
                Dim row As DataRowView = DirectCast(cboSubcategory.Items(i), DataRowView)
                If row("SubcategoryName").ToString() = subcategoryName Then
                    cboSubcategory.SelectedIndex = i
                    Exit For
                End If
            Next
        End If
    End Sub

    Public Function ValidateSelection() As String
        If Not IsValidSelection Then
            If Not _selectedCategoryID.HasValue Then
                Return "Please select a Category"
            ElseIf Not _selectedSubcategoryID.HasValue Then
                Return "Please select a Subcategory"
            ElseIf SelectedCategoryName = "Uncategorized" OrElse SelectedSubcategoryName = "General" Then
                Return "Cannot use 'Uncategorized' category or 'General' subcategory. Please select proper classification."
            End If
        End If
        Return String.Empty
    End Function
End Class
