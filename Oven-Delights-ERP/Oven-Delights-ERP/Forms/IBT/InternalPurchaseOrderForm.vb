Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for creating Internal Purchase Orders (Branch A requests products from Branch B)
    ''' </summary>
    Public Class InternalPurchaseOrderForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private _currentBranchId As Integer
        Private _currentUserId As Integer
        Private _isLoading As Boolean = False

        ' UI Controls
        Private cboSupplyingBranch As ComboBox
        Private cboProduct As ComboBox
        Private txtQuantity As TextBox
        Private dtpRequiredBy As DateTimePicker
        Private txtNotes As TextBox
        Private dgvItems As DataGridView
        Private btnAddItem As Button
        Private btnRemoveItem As Button
        Private btnSave As Button
        Private btnCancel As Button
        Private lblPONumber As Label
        Private lblTotalItems As Label

        ' Data
        Private itemsTable As DataTable
        Private branches As DataTable
        Private products As DataTable

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDanger As Color = Color.FromArgb(231, 76, 60)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New()
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)
            _currentUserId = If(AppSession.CurrentUser?.UserID, 1)
            
            Me.Text = "Create Internal Purchase Order"
            Me.Width = 1200
            Me.Height = 700
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White
            
            InitializeDataTable()
            InitializeUI()
            LoadData()
        End Sub

        Private Sub InitializeDataTable()
            itemsTable = New DataTable()
            itemsTable.Columns.Add("ProductID", GetType(Integer))
            itemsTable.Columns.Add("ProductName", GetType(String))
            itemsTable.Columns.Add("Quantity", GetType(Decimal))
            itemsTable.Columns.Add("RequiredByDate", GetType(DateTime))
            itemsTable.Columns.Add("Notes", GetType(String))
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = ColorDark
            }

            Dim lblTitle As New Label With {
                .Text = "📋 Create Internal Purchase Order",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }

            Dim lblSubtitle As New Label With {
                .Text = "Request products from another branch",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }

            lblPONumber = New Label With {
                .Text = "PO: (New)",
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = Color.FromArgb(243, 156, 18),
                .AutoSize = True,
                .Location = New Point(Me.Width - 250, 30)
            }

            pnlHeader.Controls.AddRange({lblTitle, lblSubtitle, lblPONumber})

            ' Input Panel
            Dim pnlInput As New Panel With {
                .Location = New Point(20, 100),
                .Size = New Size(1160, 120),
                .BackColor = ColorLight,
                .BorderStyle = BorderStyle.FixedSingle
            }

            ' Supplying Branch
            Dim lblSupplyingBranch As New Label With {
                .Text = "Request From Branch:",
                .Location = New Point(15, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            cboSupplyingBranch = New ComboBox With {
                .Location = New Point(15, 40),
                .Width = 250,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }

            ' Product
            Dim lblProduct As New Label With {
                .Text = "Product:",
                .Location = New Point(285, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            cboProduct = New ComboBox With {
                .Location = New Point(285, 40),
                .Width = 350,
                .DropDownStyle = ComboBoxStyle.DropDown,
                .AutoCompleteMode = AutoCompleteMode.SuggestAppend,
                .AutoCompleteSource = AutoCompleteSource.ListItems,
                .Font = New Font("Segoe UI", 10)
            }

            ' Quantity
            Dim lblQuantity As New Label With {
                .Text = "Quantity:",
                .Location = New Point(655, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            txtQuantity = New TextBox With {
                .Location = New Point(655, 40),
                .Width = 100,
                .Font = New Font("Segoe UI", 10),
                .TextAlign = HorizontalAlignment.Right
            }

            ' Required By Date
            Dim lblRequiredBy As New Label With {
                .Text = "Required By:",
                .Location = New Point(775, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            dtpRequiredBy = New DateTimePicker With {
                .Location = New Point(775, 40),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Font = New Font("Segoe UI", 10),
                .Value = DateTime.Now.AddDays(7)
            }

            ' Notes
            Dim lblNotes As New Label With {
                .Text = "Notes:",
                .Location = New Point(15, 75),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            txtNotes = New TextBox With {
                .Location = New Point(80, 72),
                .Width = 845,
                .Font = New Font("Segoe UI", 10)
            }

            ' Add Item Button
            btnAddItem = New Button With {
                .Text = "➕ Add Item",
                .Location = New Point(945, 35),
                .Size = New Size(200, 35),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnAddItem.FlatAppearance.BorderSize = 0
            AddHandler btnAddItem.Click, AddressOf BtnAddItem_Click

            pnlInput.Controls.AddRange({lblSupplyingBranch, cboSupplyingBranch, lblProduct, cboProduct,
                                       lblQuantity, txtQuantity, lblRequiredBy, dtpRequiredBy,
                                       lblNotes, txtNotes, btnAddItem})

            ' Grid
            dgvItems = New DataGridView With {
                .Location = New Point(20, 240),
                .Size = New Size(1160, 300),
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .AutoGenerateColumns = False,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.FixedSingle,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .ReadOnly = True,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 10)
            }

            ' Grid Columns
            dgvItems.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .Visible = False, .DataPropertyName = "ProductID"})
            dgvItems.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product", .Width = 400, .DataPropertyName = "ProductName"})
            dgvItems.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 150, .DataPropertyName = "Quantity", .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N4"}})
            dgvItems.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "RequiredByDate", .HeaderText = "Required By", .Width = 150, .DataPropertyName = "RequiredByDate", .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "dd/MM/yyyy"}})
            dgvItems.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Notes", .HeaderText = "Notes", .Width = 440, .DataPropertyName = "Notes"})

            dgvItems.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvItems.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvItems.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvItems.ColumnHeadersHeight = 40
            dgvItems.AlternatingRowsDefaultCellStyle.BackColor = ColorLight

            dgvItems.DataSource = itemsTable

            ' Footer Panel
            Dim pnlFooter As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 80,
                .BackColor = ColorLight
            }

            lblTotalItems = New Label With {
                .Text = "Total Items: 0",
                .Location = New Point(20, 25),
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorDark,
                .AutoSize = True
            }

            btnRemoveItem = New Button With {
                .Text = "🗑️ Remove Selected",
                .Location = New Point(700, 20),
                .Size = New Size(150, 40),
                .BackColor = ColorDanger,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRemoveItem.FlatAppearance.BorderSize = 0
            AddHandler btnRemoveItem.Click, AddressOf BtnRemoveItem_Click

            btnCancel = New Button With {
                .Text = "Cancel",
                .Location = New Point(870, 20),
                .Size = New Size(140, 40),
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnCancel.FlatAppearance.BorderSize = 0
            AddHandler btnCancel.Click, AddressOf BtnCancel_Click

            btnSave = New Button With {
                .Text = "💾 Submit Request",
                .Location = New Point(1020, 20),
                .Size = New Size(160, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnSave.FlatAppearance.BorderSize = 0
            AddHandler btnSave.Click, AddressOf BtnSave_Click

            pnlFooter.Controls.AddRange({lblTotalItems, btnRemoveItem, btnCancel, btnSave})

            Me.Controls.AddRange({pnlHeader, pnlInput, dgvItems, pnlFooter})
        End Sub

        Private Sub LoadData()
            _isLoading = True
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    ' Load Branches (exclude current branch)
                    branches = New DataTable()
                    Dim sqlBranches = "SELECT BranchID, BranchName FROM Branches WHERE BranchID <> @CurrentBranch AND IsActive = 1 ORDER BY BranchName"
                    Using cmd As New SqlCommand(sqlBranches, con)
                        cmd.Parameters.AddWithValue("@CurrentBranch", _currentBranchId)
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(branches)
                        End Using
                    End Using

                    cboSupplyingBranch.DataSource = branches
                    cboSupplyingBranch.DisplayMember = "BranchName"
                    cboSupplyingBranch.ValueMember = "BranchID"
                    cboSupplyingBranch.SelectedIndex = -1

                    ' Load Products (all active products)
                    products = New DataTable()
                    Dim sqlProducts = "SELECT DISTINCT ProductID, Name FROM Demo_Retail_Product WHERE IsActive = 1 AND (ProductType <> 'Internal' OR ProductType IS NULL) ORDER BY Name"
                    Using cmd As New SqlCommand(sqlProducts, con)
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(products)
                        End Using
                    End Using

                    cboProduct.DataSource = products
                    cboProduct.DisplayMember = "Name"
                    cboProduct.ValueMember = "ProductID"
                    cboProduct.SelectedIndex = -1
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Finally
                _isLoading = False
            End Try
        End Sub

        Private Sub BtnAddItem_Click(sender As Object, e As EventArgs)
            Try
                ' Validate
                If cboSupplyingBranch.SelectedIndex = -1 Then
                    MessageBox.Show("Please select a supplying branch.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    cboSupplyingBranch.Focus()
                    Return
                End If

                If cboProduct.SelectedIndex = -1 Then
                    MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    cboProduct.Focus()
                    Return
                End If

                Dim qty As Decimal
                If Not Decimal.TryParse(txtQuantity.Text, qty) OrElse qty <= 0 Then
                    MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtQuantity.Focus()
                    Return
                End If

                ' Check if product already added
                Dim productId As Integer = Convert.ToInt32(cboProduct.SelectedValue)
                For Each row As DataRow In itemsTable.Rows
                    If Convert.ToInt32(row("ProductID")) = productId Then
                        MessageBox.Show("This product is already in the list. Remove it first to change quantity.", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                        Return
                    End If
                Next

                ' Add item
                Dim newRow = itemsTable.NewRow()
                newRow("ProductID") = productId
                newRow("ProductName") = cboProduct.Text
                newRow("Quantity") = qty
                newRow("RequiredByDate") = dtpRequiredBy.Value
                newRow("Notes") = txtNotes.Text.Trim()
                itemsTable.Rows.Add(newRow)

                ' Clear inputs
                cboProduct.SelectedIndex = -1
                txtQuantity.Clear()
                txtNotes.Clear()
                dtpRequiredBy.Value = DateTime.Now.AddDays(7)

                UpdateTotalItems()
                cboProduct.Focus()

            Catch ex As Exception
                MessageBox.Show($"Error adding item: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnRemoveItem_Click(sender As Object, e As EventArgs)
            If dgvItems.SelectedRows.Count > 0 Then
                Dim index = dgvItems.SelectedRows(0).Index
                itemsTable.Rows(index).Delete()
                UpdateTotalItems()
            Else
                MessageBox.Show("Please select an item to remove.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        End Sub

        Private Sub UpdateTotalItems()
            lblTotalItems.Text = $"Total Items: {itemsTable.Rows.Count}"
        End Sub

        Private Sub BtnSave_Click(sender As Object, e As EventArgs)
            Try
                If itemsTable.Rows.Count = 0 Then
                    MessageBox.Show("Please add at least one item to the request.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                If MessageBox.Show("Submit this Internal Purchase Order?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> DialogResult.Yes Then
                    Return
                End If

                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Using tx = con.BeginTransaction()
                        Try
                            Dim supplyingBranchId As Integer = Convert.ToInt32(cboSupplyingBranch.SelectedValue)
                            
                            ' Get branch code for PO number
                            Dim branchCode As String = ""
                            Using cmdCode As New SqlCommand("SELECT BranchCode FROM Branches WHERE BranchID = @BranchID", con, tx)
                                cmdCode.Parameters.AddWithValue("@BranchID", _currentBranchId)
                                branchCode = If(cmdCode.ExecuteScalar() IsNot Nothing, cmdCode.ExecuteScalar().ToString(), "BR")
                            End Using

                            ' Save each item as separate PO
                            For Each row As DataRow In itemsTable.Rows
                                ' Generate PO Number
                                Dim poNumber As String = GeneratePONumber(con, tx, branchCode)

                                ' Insert PO
                                Dim sql = "INSERT INTO InternalPurchaseOrders (PONumber, RequestingBranchID, SupplyingBranchID, ProductID, Quantity, RequestedDate, RequiredByDate, Status, Notes, CreatedBy, CreatedDate) " &
                                         "VALUES (@PONumber, @RequestingBranch, @SupplyingBranch, @ProductID, @Qty, GETDATE(), @RequiredBy, 'Pending', @Notes, @UserID, GETDATE())"

                                Using cmd As New SqlCommand(sql, con, tx)
                                    cmd.Parameters.AddWithValue("@PONumber", poNumber)
                                    cmd.Parameters.AddWithValue("@RequestingBranch", _currentBranchId)
                                    cmd.Parameters.AddWithValue("@SupplyingBranch", supplyingBranchId)
                                    cmd.Parameters.AddWithValue("@ProductID", row("ProductID"))
                                    cmd.Parameters.AddWithValue("@Qty", row("Quantity"))
                                    cmd.Parameters.AddWithValue("@RequiredBy", row("RequiredByDate"))
                                    cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(row("Notes").ToString()), DBNull.Value, row("Notes")))
                                    cmd.Parameters.AddWithValue("@UserID", _currentUserId)
                                    cmd.ExecuteNonQuery()
                                End Using
                            Next

                            tx.Commit()
                            MessageBox.Show($"Internal Purchase Order submitted successfully!{vbCrLf}{itemsTable.Rows.Count} item(s) requested.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Me.DialogResult = DialogResult.OK
                            Me.Close()

                        Catch ex As Exception
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using

            Catch ex As Exception
                MessageBox.Show($"Error saving PO: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function GeneratePONumber(con As SqlConnection, tx As SqlTransaction, branchCode As String) As String
            ' Get next number
            Dim nextNumber As Integer = 1
            Dim pattern As String = $"{branchCode}-i-PO-IBT-%"
            
            Using cmd As New SqlCommand("SELECT MAX(CAST(RIGHT(PONumber, 5) AS INT)) FROM InternalPurchaseOrders WHERE PONumber LIKE @Pattern", con, tx)
                cmd.Parameters.AddWithValue("@Pattern", pattern)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    nextNumber = Convert.ToInt32(result) + 1
                End If
            End Using

            Return $"{branchCode}-i-PO-IBT-{nextNumber.ToString("00000")}"
        End Function

        Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
            Me.Close()
        End Sub
    End Class
End Namespace
