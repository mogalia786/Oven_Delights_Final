Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class ProductSKUAssignmentForm
    Inherits Form

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private dgvProducts As DataGridView
    Private txtSKUFilter As TextBox
    Private btnRefresh As Button
    Private btnSave As Button
    Private lblStatus As Label

    Public Sub New()
        Me.Text = "Assign SKU/Barcodes to Products"
        Me.Width = 1000
        Me.Height = 600
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUI()
        LoadProducts()
    End Sub

    Private Sub InitializeUI()
        ' Filter controls
        Dim lblFilter As New Label With {
            .Text = "Filter by SKU:",
            .Location = New Point(10, 15),
            .Size = New Size(80, 20)
        }

        txtSKUFilter = New TextBox With {
            .Location = New Point(95, 12),
            .Size = New Size(200, 25)
        }

        btnRefresh = New Button With {
            .Text = "Refresh",
            .Location = New Point(305, 10),
            .Size = New Size(80, 30)
        }

        ' Products grid
        dgvProducts = New DataGridView With {
            .Location = New Point(10, 50),
            .Size = New Size(960, 450),
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }

        ' Action buttons
        btnSave = New Button With {
            .Text = "Save SKU Changes",
            .Location = New Point(10, 520),
            .Size = New Size(150, 35),
            .BackColor = Color.LightGreen
        }

        lblStatus = New Label With {
            .Location = New Point(170, 530),
            .Size = New Size(400, 20),
            .ForeColor = Color.Blue
        }

        ' Add controls
        Me.Controls.AddRange({lblFilter, txtSKUFilter, btnRefresh, dgvProducts, btnSave, lblStatus})

        ' Event handlers
        AddHandler btnRefresh.Click, AddressOf OnRefresh
        AddHandler btnSave.Click, AddressOf OnSave
        AddHandler txtSKUFilter.KeyDown, AddressOf OnFilterKeyDown
    End Sub

    Private Sub LoadProducts()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                Dim sql As String = "
                    SELECT 
                        mp.ProductID,
                        mp.SKU,
                        mp.Code,
                        mp.ProductName,
                        mp.Category,
                        mp.Subcategory,
                        mp.CreatedDate,
                        CASE 
                            WHEN mp.SKU IS NULL OR mp.SKU = '' THEN 'Missing SKU'
                            ELSE 'Has SKU'
                        END AS SKUStatus
                    FROM dbo.Products mp
                    WHERE mp.IsActive = 1 AND mp.ItemType = 'Manufactured'
                    ORDER BY mp.CreatedDate DESC"

                Using adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvProducts.DataSource = dt
                End Using
            End Using

            ' Configure columns
            ConfigureGrid()
            lblStatus.Text = $"Loaded {dgvProducts.Rows.Count} products"

        Catch ex As Exception
            MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ConfigureGrid()
        With dgvProducts
            .Columns("ProductID").ReadOnly = True
            .Columns("ProductID").Width = 80

            .Columns("SKU").HeaderText = "SKU/Barcode"
            .Columns("SKU").Width = 150

            .Columns("Code").ReadOnly = True
            .Columns("Code").Width = 100

            .Columns("ProductName").ReadOnly = True
            .Columns("ProductName").Width = 200

            .Columns("Category").ReadOnly = True
            .Columns("Category").Width = 120

            .Columns("Subcategory").ReadOnly = True
            .Columns("Subcategory").Width = 120

            .Columns("CreatedDate").ReadOnly = True
            .Columns("CreatedDate").Width = 120

            .Columns("SKUStatus").ReadOnly = True
            .Columns("SKUStatus").Width = 100
        End With

        ' Highlight rows missing SKU
        For Each row As DataGridViewRow In dgvProducts.Rows
            If row.Cells("SKUStatus").Value?.ToString() = "Missing SKU" Then
                row.DefaultCellStyle.BackColor = Color.LightYellow
            End If
        Next
    End Sub

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadProducts()
    End Sub

    Private Sub OnFilterKeyDown(sender As Object, e As KeyEventArgs)
        If e.KeyCode = Keys.Enter Then
            FilterProducts()
        End If
    End Sub

    Private Sub FilterProducts()
        Try
            Dim filter As String = txtSKUFilter.Text.Trim()
            Dim dt As DataTable = CType(dgvProducts.DataSource, DataTable)

            If String.IsNullOrEmpty(filter) Then
                dt.DefaultView.RowFilter = ""
            Else
                dt.DefaultView.RowFilter = $"SKU LIKE '%{filter}%' OR ProductName LIKE '%{filter}%'"
            End If

        Catch ex As Exception
            MessageBox.Show($"Error filtering: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            Dim updatedCount As Integer = 0

            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using trans As SqlTransaction = conn.BeginTransaction()

                    For Each row As DataGridViewRow In dgvProducts.Rows
                        If Not row.IsNewRow Then
                            Dim productId As Integer = Convert.ToInt32(row.Cells("ProductID").Value)
                            Dim newSKU As String = row.Cells("SKU").Value?.ToString()?.Trim()

                            ' Update SKU in Products table
                            Dim sql As String = "UPDATE dbo.Products SET SKU = @sku WHERE ProductID = @id"
                            Using cmd As New SqlCommand(sql, conn, trans)
                                cmd.Parameters.AddWithValue("@sku", If(String.IsNullOrEmpty(newSKU), "", newSKU))
                                cmd.Parameters.AddWithValue("@id", productId)

                                If cmd.ExecuteNonQuery() > 0 Then
                                    updatedCount += 1
                                End If
                            End Using
                        End If
                    Next

                    trans.Commit()
                    lblStatus.Text = $"Updated {updatedCount} products successfully"
                    lblStatus.ForeColor = Color.Green

                    ' Refresh to show updated status
                    LoadProducts()
                End Using
            End Using

        Catch ex As Exception
            MessageBox.Show($"Error saving SKU changes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            lblStatus.Text = "Save failed"
            lblStatus.ForeColor = Color.Red
        End Try
    End Sub

End Class
