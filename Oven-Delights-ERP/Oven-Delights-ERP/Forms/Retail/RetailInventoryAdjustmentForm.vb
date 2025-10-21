Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.ComponentModel

Public Class RetailInventoryAdjustmentForm
    Private currentUser As User

    Public Sub New()
        InitializeComponent()
    End Sub

    Public Sub New(user As User)
        InitializeComponent()
        currentUser = user
    End Sub

    Private Sub RetailInventoryAdjustmentForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            LoadProducts()
            SetupForm()
        Catch ex As Exception
            MessageBox.Show($"Error loading form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupForm()
        Me.Text = "Retail Inventory Adjustment"
        dtpAdjustmentDate.Value = DateTime.Today
        cmbAdjustmentType.Items.Clear()
        cmbAdjustmentType.Items.AddRange({"Increase", "Decrease", "Count Adjustment"})
        cmbAdjustmentType.SelectedIndex = 0
        txtQuantity.Text = "0"
        txtReason.Text = ""
    End Sub

    Private Sub LoadProducts()
        Try
            cmbProduct.Items.Clear()
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New SqlCommand("SELECT p.ProductID, p.ProductCode, p.ProductName FROM Products p WHERE p.IsActive = 1 ORDER BY p.ProductName", conn)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim displayText = $"{reader("ProductCode")} - {reader("ProductName")}"
                        cmbProduct.Items.Add(New ComboBoxItem(displayText, reader("ProductID")))
                    End While
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub cmbProduct_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbProduct.SelectedIndexChanged
        If cmbProduct.SelectedItem IsNot Nothing Then
            LoadCurrentStock()
        End If
    End Sub

    Private Sub LoadCurrentStock()
        Try
            Dim productId As Integer = DirectCast(cmbProduct.SelectedItem, ComboBoxItem).Value
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SUM(ISNULL(rs.QtyOnHand, 0)) FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @ProductID", conn)
                cmd.Parameters.AddWithValue("@ProductID", productId)
                Dim result = cmd.ExecuteScalar()
                lblCurrentStock.Text = $"Current Stock: {If(result, 0)}"
            End Using
        Catch ex As Exception
            lblCurrentStock.Text = "Current Stock: Unknown"
        End Try
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ValidateForm() Then
            SaveAdjustment()
        End If
    End Sub

    Private Function ValidateForm() As Boolean
        If cmbProduct.SelectedItem Is Nothing Then
            MessageBox.Show("Please select a product.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cmbProduct.Focus()
            Return False
        End If

        If cmbAdjustmentType.SelectedItem Is Nothing Then
            MessageBox.Show("Please select an adjustment type.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cmbAdjustmentType.Focus()
            Return False
        End If

        Dim quantity As Integer
        If Not Integer.TryParse(txtQuantity.Text, quantity) OrElse quantity <= 0 Then
            MessageBox.Show("Please enter a valid quantity greater than zero.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtQuantity.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtReason.Text) Then
            MessageBox.Show("Please provide a reason for the adjustment.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtReason.Focus()
            Return False
        End If

        Return True
    End Function

    Private Sub SaveAdjustment()
        Try
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Using trans As SqlTransaction = conn.BeginTransaction()
                    Try
                        Dim productId As Integer = DirectCast(cmbProduct.SelectedItem, ComboBoxItem).Value
                        Dim adjustmentType As String = cmbAdjustmentType.SelectedItem.ToString()
                        Dim quantity As Integer = Convert.ToInt32(txtQuantity.Text)

                        ' Insert adjustment record
                        Dim insertCmd As New SqlCommand("INSERT INTO InventoryAdjustments (ProductID, AdjustmentType, Quantity, Reason, AdjustmentDate, CreatedBy) VALUES (@ProductID, @AdjustmentType, @Quantity, @Reason, @AdjustmentDate, @CreatedBy)", conn, trans)
                        insertCmd.Parameters.AddWithValue("@ProductID", productId)
                        insertCmd.Parameters.AddWithValue("@AdjustmentType", adjustmentType)
                        insertCmd.Parameters.AddWithValue("@Quantity", quantity)
                        insertCmd.Parameters.AddWithValue("@Reason", txtReason.Text.Trim())
                        insertCmd.Parameters.AddWithValue("@AdjustmentDate", dtpAdjustmentDate.Value.Date)
                        insertCmd.Parameters.AddWithValue("@CreatedBy", currentUser.UserID)
                        insertCmd.ExecuteNonQuery()

                        ' Update inventory based on adjustment type - use Retail_Stock with Retail_Variant
                        Dim updateSql As String = ""
                        Select Case adjustmentType
                            Case "Increase"
                                updateSql = "UPDATE rs SET rs.QtyOnHand = rs.QtyOnHand + @Quantity FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @ProductID"
                            Case "Decrease"
                                updateSql = "UPDATE rs SET rs.QtyOnHand = rs.QtyOnHand - @Quantity FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @ProductID"
                            Case "Count Adjustment"
                                updateSql = "UPDATE rs SET rs.QtyOnHand = @Quantity FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @ProductID"
                        End Select

                        Dim updateCmd As New SqlCommand(updateSql, conn, trans)
                        updateCmd.Parameters.AddWithValue("@ProductID", productId)
                        updateCmd.Parameters.AddWithValue("@Quantity", quantity)
                        updateCmd.ExecuteNonQuery()

                        trans.Commit()
                        MessageBox.Show("Inventory adjustment saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Me.DialogResult = DialogResult.OK
                        Me.Close()

                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving adjustment: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    Private Function GetConnectionString() As String
        Return ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Function

    Public Class ComboBoxItem
        Public Property Text As String
        Public Property Value As Object

        Public Sub New(text As String, value As Object)
            Me.Text = text
            Me.Value = value
        End Sub

        Public Overrides Function ToString() As String
            Return Text
        End Function
    End Class
End Class
