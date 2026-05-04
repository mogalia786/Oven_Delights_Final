Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing
Imports System.Diagnostics

Namespace Manufacturing
    Public Class RecipeBuilderForm
        Inherits Form

        ' Controls
        Private pnlHeader As Panel
        Private cboProduct As ComboBox
        Private txtRecipeName As TextBox
        Private nudBatchYield As NumericUpDown
        Private txtBatchUoM As TextBox
        Private dgvIngredients As DataGridView
        Private btnAddRawMaterial As Button
        ' REMOVED: Private btnAddSubAssembly As Button - Sub-recipes now in Add Ingredient
        Private btnRemove As Button
        Private txtMethod As RichTextBox
        Private nudPrepTime As NumericUpDown
        Private nudCookTime As NumericUpDown
        Private btnSave As Button
        Private btnPrint As Button
        Private btnEmail As Button
        Private btnClose As Button
        Private lblStatus As Label

        ' Data
        Private currentRecipeID As Integer = 0
        Private dtIngredients As DataTable

        Public Sub New()
            InitializeComponent()
            LoadProducts()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Build My Product - Recipe Builder"
            Me.Size = New Size(1400, 1000)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.FromArgb(248, 249, 250)
            Me.Font = New Font("Segoe UI", 10)

            ' Header
            pnlHeader = New Panel With {
                .Dock = DockStyle.Top,
                .Height = 70,
                .BackColor = Color.FromArgb(0, 120, 212)
            }
            Dim lblTitle As New Label With {
                .Text = "🎂 Build My Product",
                .Font = New Font("Segoe UI", 20, FontStyle.Bold),
                .ForeColor = Color.White,
                .Location = New Point(20, 15),
                .AutoSize = True
            }
            pnlHeader.Controls.Add(lblTitle)

            ' Product Section
            Dim pnlProduct As New Panel With {
                .Location = New Point(20, 90),
                .Size = New Size(1340, 120),
                .BackColor = Color.White,
                .BorderStyle = BorderStyle.FixedSingle
            }

            Dim lblProduct As New Label With {
                .Text = "Product:",
                .Location = New Point(20, 20),
                .Size = New Size(100, 25),
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            cboProduct = New ComboBox With {
                .Location = New Point(130, 18),
                .Size = New Size(400, 28),
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }

            Dim lblRecipeName As New Label With {
                .Text = "Recipe Name:",
                .Location = New Point(560, 20),
                .Size = New Size(110, 25),
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            txtRecipeName = New TextBox With {
                .Location = New Point(680, 18),
                .Size = New Size(400, 28),
                .Font = New Font("Segoe UI", 10)
            }

            Dim lblBatch As New Label With {
                .Text = "Batch Yield:",
                .Location = New Point(20, 70),
                .Size = New Size(100, 25),
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            nudBatchYield = New NumericUpDown With {
                .Location = New Point(130, 68),
                .Size = New Size(120, 28),
                .DecimalPlaces = 2,
                .Minimum = 0.01D,
                .Maximum = 100000D,
                .Value = 1D,
                .Font = New Font("Segoe UI", 10)
            }
            txtBatchUoM = New TextBox With {
                .Location = New Point(260, 68),
                .Size = New Size(80, 28),
                .Text = "ea",
                .Font = New Font("Segoe UI", 10)
            }

            pnlProduct.Controls.AddRange({lblProduct, cboProduct, lblRecipeName, txtRecipeName, lblBatch, nudBatchYield, txtBatchUoM})

            ' Ingredients Section
            Dim lblIngredients As New Label With {
                .Text = "📋 INGREDIENTS",
                .Location = New Point(20, 230),
                .Size = New Size(200, 30),
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = Color.FromArgb(0, 120, 212)
            }

            Dim pnlButtons As New Panel With {
                .Location = New Point(20, 265),
                .Size = New Size(1340, 50),
                .BackColor = Color.FromArgb(240, 240, 240)
            }

            btnAddRawMaterial = New Button With {
                .Text = "➕ Add Components",
                .Location = New Point(10, 8),
                .Size = New Size(220, 34),
                .BackColor = Color.FromArgb(40, 167, 69),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnAddRawMaterial.FlatAppearance.BorderSize = 0

            ' REMOVED: btnAddSubAssembly - Sub-recipes are now included in Add Ingredient button

            btnRemove = New Button With {
                .Text = "🗑️ Remove",
                .Location = New Point(240, 8),
                .Size = New Size(140, 34),
                .BackColor = Color.FromArgb(220, 53, 69),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRemove.FlatAppearance.BorderSize = 0

            pnlButtons.Controls.AddRange({btnAddRawMaterial, btnRemove})

            dgvIngredients = New DataGridView With {
                .Location = New Point(20, 320),
                .Size = New Size(1340, 300),
                .BackgroundColor = Color.White,
                .AllowUserToAddRows = False,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .Font = New Font("Segoe UI", 10),
                .RowHeadersWidth = 40,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            }
            dgvIngredients.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(0, 120, 212)
            dgvIngredients.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvIngredients.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvIngredients.ColumnHeadersHeight = 35
            dgvIngredients.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(250, 250, 250)

            ' Method Section
            Dim lblMethod As New Label With {
                .Text = "📝 METHOD",
                .Location = New Point(20, 640),
                .Size = New Size(150, 30),
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = Color.FromArgb(0, 120, 212)
            }

            txtMethod = New RichTextBox With {
                .Location = New Point(20, 675),
                .Size = New Size(900, 120),
                .Font = New Font("Segoe UI", 10)
            }

            ' Times
            Dim lblPrep As New Label With {
                .Text = "⏱️ Prep (min):",
                .Location = New Point(940, 675),
                .Size = New Size(120, 25),
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            nudPrepTime = New NumericUpDown With {
                .Location = New Point(1070, 673),
                .Size = New Size(80, 28),
                .Maximum = 10000
            }

            Dim lblCook As New Label With {
                .Text = "🔥 Cook (min):",
                .Location = New Point(940, 720),
                .Size = New Size(120, 25),
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            nudCookTime = New NumericUpDown With {
                .Location = New Point(1070, 718),
                .Size = New Size(80, 28),
                .Maximum = 10000
            }

            ' Actions
            Dim pnlActions As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 60,
                .BackColor = Color.FromArgb(240, 240, 240)
            }

            btnSave = New Button With {
                .Text = "💾 Save Recipe",
                .Location = New Point(20, 10),
                .Size = New Size(160, 40),
                .BackColor = Color.FromArgb(40, 167, 69),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnSave.FlatAppearance.BorderSize = 0

            btnPrint = New Button With {
                .Text = "🖨️ Print Recipe",
                .Location = New Point(190, 10),
                .Size = New Size(160, 40),
                .BackColor = Color.FromArgb(0, 123, 255),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnPrint.FlatAppearance.BorderSize = 0

            btnEmail = New Button With {
                .Text = "📧 Email Recipe",
                .Location = New Point(360, 10),
                .Size = New Size(160, 40),
                .BackColor = Color.FromArgb(108, 117, 125),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnEmail.FlatAppearance.BorderSize = 0

            btnClose = New Button With {
                .Text = "❌ Close",
                .Location = New Point(1220, 10),
                .Size = New Size(140, 40),
                .BackColor = Color.FromArgb(220, 53, 69),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnClose.FlatAppearance.BorderSize = 0

            pnlActions.Controls.AddRange({btnSave, btnPrint, btnEmail, btnClose})

            ' Status
            lblStatus = New Label With {
                .Dock = DockStyle.Bottom,
                .Height = 30,
                .BackColor = Color.FromArgb(233, 236, 239),
                .TextAlign = ContentAlignment.MiddleLeft,
                .Padding = New Padding(20, 0, 0, 0),
                .Text = "Ready to create recipes..."
            }

            Controls.AddRange({pnlHeader, pnlProduct, lblIngredients, pnlButtons, dgvIngredients, lblMethod, txtMethod, lblPrep, nudPrepTime, lblCook, nudCookTime, pnlActions, lblStatus})

            ' Initialize data AFTER controls are created
            InitializeData()

            AddHandler cboProduct.SelectedIndexChanged, AddressOf OnProductChanged
            AddHandler btnAddRawMaterial.Click, AddressOf OnAddRawMaterial
            ' REMOVED: AddHandler btnAddSubAssembly.Click - Sub-recipes now in Add Ingredient
            AddHandler btnRemove.Click, AddressOf OnRemove
            AddHandler btnSave.Click, AddressOf OnSave
            AddHandler btnPrint.Click, AddressOf OnPrint
            AddHandler btnEmail.Click, AddressOf OnEmail
            AddHandler btnClose.Click, Sub() Me.Close()
        End Sub

        Private Sub InitializeData()
            dtIngredients = New DataTable
            dtIngredients.Columns.Add("ID", GetType(Integer))
            dtIngredients.Columns.Add("IngredientType", GetType(String))
            dtIngredients.Columns.Add("Component", GetType(String))
            dtIngredients.Columns.Add("Quantity", GetType(Decimal))
            dtIngredients.Columns.Add("Unit", GetType(String))
            dtIngredients.Columns.Add("MaterialID", GetType(Integer))
            dtIngredients.Columns.Add("SubAssemblyID", GetType(Integer))

            dgvIngredients.DataSource = dtIngredients
        End Sub

        Private Sub LoadProducts()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql = "SELECT ProductID, SKU + ' - ' + Name AS DisplayText FROM dbo.Demo_Retail_Product WHERE ProductType = 'Internal' AND ISNULL(IsActive, 1) = 1 ORDER BY Name"
                    Using cmd As New SqlCommand(sql, cn), da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        cboProduct.DataSource = dt
                        cboProduct.DisplayMember = "DisplayText"
                        cboProduct.ValueMember = "ProductID"
                        cboProduct.SelectedIndex = -1
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnProductChanged(sender As Object, e As EventArgs)
            If cboProduct.SelectedValue IsNot Nothing AndAlso IsNumeric(cboProduct.SelectedValue) Then
                LoadRecipe(Convert.ToInt32(cboProduct.SelectedValue))
            End If
        End Sub

        Private Sub LoadRecipe(productID As Integer)
            Try
                dtIngredients.Clear()
                currentRecipeID = 0

                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql = "SELECT * FROM dbo.Recipe WHERE ProductID = @pid AND IsActive = 1"
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@pid", productID)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                currentRecipeID = reader.GetInt32(reader.GetOrdinal("RecipeID"))
                                txtRecipeName.Text = reader.GetString(reader.GetOrdinal("RecipeName"))
                                nudBatchYield.Value = reader.GetDecimal(reader.GetOrdinal("BatchYield"))
                                If Not reader.IsDBNull(reader.GetOrdinal("BatchYieldUoM")) Then txtBatchUoM.Text = reader.GetString(reader.GetOrdinal("BatchYieldUoM"))
                                If Not reader.IsDBNull(reader.GetOrdinal("Method")) Then txtMethod.Text = reader.GetString(reader.GetOrdinal("Method"))
                                If Not reader.IsDBNull(reader.GetOrdinal("PrepTime")) Then nudPrepTime.Value = reader.GetInt32(reader.GetOrdinal("PrepTime"))
                                If Not reader.IsDBNull(reader.GetOrdinal("CookTime")) Then nudCookTime.Value = reader.GetInt32(reader.GetOrdinal("CookTime"))
                                lblStatus.Text = $"✅ Loaded recipe: {txtRecipeName.Text}"
                            Else
                                Dim productName = CType(cboProduct.SelectedItem, DataRowView)("DisplayText").ToString()
                                txtRecipeName.Text = productName.Split("-"c)(1).Trim() & " Recipe"
                                nudBatchYield.Value = 1
                                txtBatchUoM.Text = "ea"
                                txtMethod.Clear()
                                nudPrepTime.Value = 0
                                nudCookTime.Value = 0
                                lblStatus.Text = "📝 Creating new recipe..."
                            End If
                        End Using
                    End Using

                    If currentRecipeID > 0 Then
                        sql = "SELECT ri.*, CASE WHEN ri.IngredientType = 'RawMaterial' THEN rm.MaterialCode + ' - ' + rm.MaterialName WHEN ri.IngredientType = 'SubAssembly' THEN p.SKU + ' - ' + p.Name ELSE ri.IngredientName END AS ComponentName FROM dbo.RecipeIngredient ri LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = ri.SubAssemblyProductID WHERE ri.RecipeID = @rid ORDER BY ri.LineNumber"
                        Using cmd As New SqlCommand(sql, cn)
                            cmd.Parameters.AddWithValue("@rid", currentRecipeID)
                            Using reader = cmd.ExecuteReader()
                                While reader.Read()
                                    Dim row = dtIngredients.NewRow()
                                    row("ID") = reader("RecipeIngredientID")
                                    row("IngredientType") = reader("IngredientType")
                                    row("Component") = reader("ComponentName")
                                    row("Quantity") = reader("Quantity")
                                    row("Unit") = If(reader.IsDBNull(reader.GetOrdinal("UoM")), "", reader("UoM"))
                                    row("MaterialID") = If(reader.IsDBNull(reader.GetOrdinal("MaterialID")), DBNull.Value, reader("MaterialID"))
                                    row("SubAssemblyID") = If(reader.IsDBNull(reader.GetOrdinal("SubAssemblyProductID")), DBNull.Value, reader("SubAssemblyProductID"))
                                    dtIngredients.Rows.Add(row)
                                End While
                            End Using
                        End Using
                    End If
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading recipe: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnAddRawMaterial(sender As Object, e As EventArgs)
            Using frm As New RawMaterialSelectorDialog()
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    Dim row = dtIngredients.NewRow()
                    row("ID") = 0

                    ' Everything is now in RawMaterials table - just use MaterialID!
                    row("IngredientType") = If(frm.SelectedType = "Sub Recipe", "SubAssembly", "RawMaterial")
                    row("MaterialID") = frm.SelectedMaterialID  ' Always from RawMaterials table
                    row("SubAssemblyID") = DBNull.Value  ' Not used anymore

                    row("Component") = frm.SelectedMaterialCode & " - " & frm.SelectedMaterialName
                    row("Quantity") = 1D
                    row("Unit") = frm.SelectedUoM
                    dtIngredients.Rows.Add(row)
                    lblStatus.Text = $"✅ Added: {frm.SelectedMaterialName} ({frm.SelectedType})"
                End If
            End Using
        End Sub

        ' REMOVED: OnAddSubAssembly method - Sub-recipes are now added via OnAddRawMaterial
        ' Sub-recipes are stored in RawMaterials table with MaterialType = 'Sub Recipe'
        ' They are selected through the same RawMaterialSelectorDialog which now shows both types

        Private Sub OnRemove(sender As Object, e As EventArgs)
            If dgvIngredients.SelectedRows.Count > 0 Then
                dgvIngredients.Rows.Remove(dgvIngredients.SelectedRows(0))
                lblStatus.Text = "🗑️ Ingredient removed"
            End If
        End Sub

        Private Sub OnSave(sender As Object, e As EventArgs)
            If cboProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If String.IsNullOrWhiteSpace(txtRecipeName.Text) Then
                MessageBox.Show("Please enter a recipe name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If dtIngredients.Rows.Count = 0 Then
                MessageBox.Show("Please add at least one ingredient.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using trans = cn.BeginTransaction()
                        Try
                            If currentRecipeID = 0 Then
                                Dim sql = "INSERT INTO dbo.Recipe (ProductID, RecipeName, BatchYield, BatchYieldUoM, Method, PrepTime, CookTime, IsActive, CreatedDate) VALUES (@pid, @name, @yield, @uom, @method, @prep, @cook, 1, GETDATE()); SELECT SCOPE_IDENTITY();"
                                Using cmd As New SqlCommand(sql, cn, trans)
                                    cmd.Parameters.AddWithValue("@pid", cboProduct.SelectedValue)
                                    cmd.Parameters.AddWithValue("@name", txtRecipeName.Text)
                                    cmd.Parameters.AddWithValue("@yield", nudBatchYield.Value)
                                    cmd.Parameters.AddWithValue("@uom", If(String.IsNullOrEmpty(txtBatchUoM.Text), DBNull.Value, CType(txtBatchUoM.Text, Object)))
                                    cmd.Parameters.AddWithValue("@method", If(String.IsNullOrEmpty(txtMethod.Text), DBNull.Value, CType(txtMethod.Text, Object)))
                                    cmd.Parameters.AddWithValue("@prep", If(nudPrepTime.Value = 0, DBNull.Value, CType(nudPrepTime.Value, Object)))
                                    cmd.Parameters.AddWithValue("@cook", If(nudCookTime.Value = 0, DBNull.Value, CType(nudCookTime.Value, Object)))
                                    Dim result = cmd.ExecuteScalar()
                                    If result Is Nothing OrElse IsDBNull(result) Then
                                        Throw New Exception("Failed to create recipe - SCOPE_IDENTITY returned NULL")
                                    End If
                                    currentRecipeID = Convert.ToInt32(result)
                                End Using
                            Else
                                Dim sql = "UPDATE dbo.Recipe SET RecipeName = @name, BatchYield = @yield, BatchYieldUoM = @uom, Method = @method, PrepTime = @prep, CookTime = @cook, ModifiedDate = GETDATE() WHERE RecipeID = @rid; DELETE FROM dbo.RecipeIngredient WHERE RecipeID = @rid"
                                Using cmd As New SqlCommand(sql, cn, trans)
                                    cmd.Parameters.AddWithValue("@rid", currentRecipeID)
                                    cmd.Parameters.AddWithValue("@name", txtRecipeName.Text)
                                    cmd.Parameters.AddWithValue("@yield", nudBatchYield.Value)
                                    cmd.Parameters.AddWithValue("@uom", If(String.IsNullOrEmpty(txtBatchUoM.Text), DBNull.Value, CType(txtBatchUoM.Text, Object)))
                                    cmd.Parameters.AddWithValue("@method", If(String.IsNullOrEmpty(txtMethod.Text), DBNull.Value, CType(txtMethod.Text, Object)))
                                    cmd.Parameters.AddWithValue("@prep", If(nudPrepTime.Value = 0, DBNull.Value, CType(nudPrepTime.Value, Object)))
                                    cmd.Parameters.AddWithValue("@cook", If(nudCookTime.Value = 0, DBNull.Value, CType(nudCookTime.Value, Object)))
                                    cmd.ExecuteNonQuery()
                                End Using
                            End If

                            ' Verify RecipeID was created
                            If currentRecipeID <= 0 Then
                                Throw New Exception("Invalid RecipeID - cannot save ingredients")
                            End If

                            Dim lineNum = 1
                            For Each row As DataRow In dtIngredients.Rows
                                Dim sql = "INSERT INTO dbo.RecipeIngredient (RecipeID, LineNumber, IngredientType, MaterialID, SubAssemblyProductID, IngredientName, Quantity, UoM) VALUES (@rid, @line, @type, @mat, @sub, @name, @qty, @uom)"
                                Using cmd As New SqlCommand(sql, cn, trans)
                                    cmd.Parameters.AddWithValue("@rid", currentRecipeID)
                                    cmd.Parameters.AddWithValue("@line", lineNum)
                                    cmd.Parameters.AddWithValue("@type", row("IngredientType"))

                                    ' SIMPLIFIED: Everything uses MaterialID now (both raw materials and sub-recipes)
                                    cmd.Parameters.AddWithValue("@mat", If(IsDBNull(row("MaterialID")), DBNull.Value, row("MaterialID")))
                                    cmd.Parameters.AddWithValue("@sub", DBNull.Value)  ' Not used anymore

                                    cmd.Parameters.AddWithValue("@name", row("Component"))
                                    cmd.Parameters.AddWithValue("@qty", row("Quantity"))
                                    cmd.Parameters.AddWithValue("@uom", If(String.IsNullOrEmpty(row("Unit").ToString()), DBNull.Value, CType(row("Unit"), Object)))
                                    cmd.ExecuteNonQuery()
                                End Using
                                lineNum += 1
                            Next

                            trans.Commit()
                            MessageBox.Show("Recipe saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            lblStatus.Text = "✅ Recipe saved successfully!"
                            lblStatus.ForeColor = Color.Green
                        Catch ex As Exception
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error saving recipe: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnPrint(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtRecipeName.Text) Then
                MessageBox.Show("Please load or create a recipe first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                ' Create print preview form
                Dim printForm As New Form With {
                    .Text = "Recipe Card - " & txtRecipeName.Text,
                    .Size = New Size(850, 1100),
                    .StartPosition = FormStartPosition.CenterParent,
                    .BackColor = Color.White
                }

                Dim rtbPrint As New RichTextBox With {
                    .Dock = DockStyle.Fill,
                    .ReadOnly = True,
                    .Font = New Font("Segoe UI", 10),
                    .BorderStyle = BorderStyle.None,
                    .Padding = New Padding(40)
                }

                ' Build recipe card content
                Dim sb As New System.Text.StringBuilder()
                sb.AppendLine("═══════════════════════════════════════════════════════")
                sb.AppendLine($"  {txtRecipeName.Text.ToUpper()}")
                sb.AppendLine("═══════════════════════════════════════════════════════")
                sb.AppendLine()
                sb.AppendLine($"Batch Yield: {nudBatchYield.Value} {txtBatchUoM.Text}")
                If nudPrepTime.Value > 0 Then sb.AppendLine($"Prep Time: {nudPrepTime.Value} minutes")
                If nudCookTime.Value > 0 Then sb.AppendLine($"Cook Time: {nudCookTime.Value} minutes")
                sb.AppendLine()
                sb.AppendLine("INGREDIENTS:")
                sb.AppendLine("───────────────────────────────────────────────────────")

                For Each row As DataRow In dtIngredients.Rows
                    sb.AppendLine($"  • {row("Quantity"):N2} {row("Unit")} - {row("Component")}")
                Next

                sb.AppendLine()
                sb.AppendLine("METHOD:")
                sb.AppendLine("───────────────────────────────────────────────────────")
                sb.AppendLine(txtMethod.Text)
                sb.AppendLine()
                sb.AppendLine("═══════════════════════════════════════════════════════")
                sb.AppendLine($"Generated: {DateTime.Now:yyyy-MM-dd HH:mm}")

                rtbPrint.Text = sb.ToString()

                ' Add print button
                Dim btnDoPrint As New Button With {
                    .Text = "🖨️ Print",
                    .Dock = DockStyle.Bottom,
                    .Height = 50,
                    .BackColor = Color.FromArgb(0, 123, 255),
                    .ForeColor = Color.White,
                    .FlatStyle = FlatStyle.Flat,
                    .Font = New Font("Segoe UI", 12, FontStyle.Bold)
                }
                btnDoPrint.FlatAppearance.BorderSize = 0

                AddHandler btnDoPrint.Click, Sub()
                                                 Dim pd As New Printing.PrintDocument()
                                                 AddHandler pd.PrintPage, Sub(s, ev)
                                                                              ev.Graphics.DrawString(sb.ToString(), New Font("Segoe UI", 10), Brushes.Black, New RectangleF(50, 50, ev.PageBounds.Width - 100, ev.PageBounds.Height - 100))
                                                                          End Sub

                                                 Dim ppd As New PrintPreviewDialog With {.Document = pd}
                                                 ppd.ShowDialog()
                                             End Sub

                printForm.Controls.Add(rtbPrint)
                printForm.Controls.Add(btnDoPrint)
                printForm.ShowDialog()

            Catch ex As Exception
                MessageBox.Show("Error printing recipe: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnEmail(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtRecipeName.Text) Then
                MessageBox.Show("Please load or create a recipe first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim emailDialog As New Form With {
                    .Text = "Email Recipe",
                    .Size = New Size(500, 200),
                    .StartPosition = FormStartPosition.CenterParent
                }

                Dim lblTo As New Label With {
                    .Text = "To:",
                    .Location = New Point(20, 30),
                    .Size = New Size(60, 25)
                }

                Dim txtTo As New TextBox With {
                    .Location = New Point(90, 28),
                    .Size = New Size(370, 25)
                }

                Dim btnSend As New Button With {
                    .Text = "Send",
                    .Location = New Point(280, 110),
                    .Size = New Size(90, 35),
                    .BackColor = Color.FromArgb(0, 123, 255),
                    .ForeColor = Color.White,
                    .FlatStyle = FlatStyle.Flat
                }

                Dim btnCancel As New Button With {
                    .Text = "Cancel",
                    .Location = New Point(380, 110),
                    .Size = New Size(80, 35),
                    .DialogResult = DialogResult.Cancel
                }

                AddHandler btnSend.Click, Sub()
                                              If String.IsNullOrWhiteSpace(txtTo.Text) Then
                                                  MessageBox.Show("Please enter an email address.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                                  Return
                                              End If

                                              Try
                                                  ' Build email body
                                                  Dim body As New System.Text.StringBuilder()
                                                  body.AppendLine($"Recipe: {txtRecipeName.Text}")
                                                  body.AppendLine($"Batch Yield: {nudBatchYield.Value} {txtBatchUoM.Text}")
                                                  body.AppendLine()
                                                  body.AppendLine("Ingredients:")
                                                  For Each row As DataRow In dtIngredients.Rows
                                                      body.AppendLine($"  • {row("Quantity"):N2} {row("Unit")} - {row("Component")}")
                                                  Next
                                                  body.AppendLine()
                                                  body.AppendLine("Method:")
                                                  body.AppendLine(txtMethod.Text)

                                                  ' Open default email client
                                                  Dim mailtoUrl = $"mailto:{txtTo.Text}?subject={Uri.EscapeDataString(txtRecipeName.Text)}&body={Uri.EscapeDataString(body.ToString())}"
                                                  Process.Start(New ProcessStartInfo(mailtoUrl) With {.UseShellExecute = True})

                                                  emailDialog.DialogResult = DialogResult.OK
                                                  emailDialog.Close()
                                                  MessageBox.Show("Email client opened successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                              Catch ex As Exception
                                                  MessageBox.Show("Error sending email: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                              End Try
                                          End Sub

                emailDialog.Controls.AddRange({lblTo, txtTo, btnSend, btnCancel})
                emailDialog.ShowDialog()

            Catch ex As Exception
                MessageBox.Show("Error preparing email: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
