Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class FixedAssetAddForm
        Inherits Form

        Private txtAssetCode As TextBox
        Private txtAssetName As TextBox
        Private cboCategory As ComboBox
        Private txtDescription As TextBox
        Private dtpPurchaseDate As DateTimePicker
        Private txtPurchasePrice As TextBox
        Private cboBranch As ComboBox
        Private txtLocation As TextBox
        Private txtSerialNumber As TextBox
        Private cboDepreciationMethod As ComboBox
        Private txtUsefulLife As TextBox
        Private txtSalvageValue As TextBox
        Private cboAssetAccount As ComboBox
        Private cboDepreciationAccount As ComboBox
        Private cboExpenseAccount As ComboBox
        Private btnSave As Button
        Private btnCancel As Button
        Private _connString As String

        Public Sub New()
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            LoadData()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Add Fixed Asset"
            Me.Size = New Size(600, 700)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            Dim yPos As Integer = 20

            ' Asset Code
            AddLabel("Asset Code:", 20, yPos)
            txtAssetCode = New TextBox() With {.Location = New Point(200, yPos), .Width = 350}
            Me.Controls.Add(txtAssetCode)
            yPos += 35

            ' Asset Name
            AddLabel("Asset Name:", 20, yPos)
            txtAssetName = New TextBox() With {.Location = New Point(200, yPos), .Width = 350}
            Me.Controls.Add(txtAssetName)
            yPos += 35

            ' Category
            AddLabel("Category:", 20, yPos)
            cboCategory = New ComboBox() With {
                .Location = New Point(200, yPos),
                .Width = 350,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            cboCategory.Items.AddRange({"Building", "Equipment", "Vehicle", "Furniture", "Computer", "Other"})
            Me.Controls.Add(cboCategory)
            yPos += 35

            ' Description
            AddLabel("Description:", 20, yPos)
            txtDescription = New TextBox() With {
                .Location = New Point(200, yPos),
                .Width = 350,
                .Height = 60,
                .Multiline = True
            }
            Me.Controls.Add(txtDescription)
            yPos += 70

            ' Purchase Date
            AddLabel("Purchase Date:", 20, yPos)
            dtpPurchaseDate = New DateTimePicker() With {
                .Location = New Point(200, yPos),
                .Width = 200,
                .Format = DateTimePickerFormat.Short
            }
            Me.Controls.Add(dtpPurchaseDate)
            yPos += 35

            ' Purchase Price
            AddLabel("Purchase Price:", 20, yPos)
            txtPurchasePrice = New TextBox() With {.Location = New Point(200, yPos), .Width = 150}
            Me.Controls.Add(txtPurchasePrice)
            yPos += 35

            ' Branch
            AddLabel("Branch:", 20, yPos)
            cboBranch = New ComboBox() With {
                .Location = New Point(200, yPos),
                .Width = 350,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            Me.Controls.Add(cboBranch)
            yPos += 35

            ' Location
            AddLabel("Location:", 20, yPos)
            txtLocation = New TextBox() With {.Location = New Point(200, yPos), .Width = 350}
            Me.Controls.Add(txtLocation)
            yPos += 35

            ' Serial Number
            AddLabel("Serial Number:", 20, yPos)
            txtSerialNumber = New TextBox() With {.Location = New Point(200, yPos), .Width = 350}
            Me.Controls.Add(txtSerialNumber)
            yPos += 35

            ' Depreciation Method
            AddLabel("Depreciation Method:", 20, yPos)
            cboDepreciationMethod = New ComboBox() With {
                .Location = New Point(200, yPos),
                .Width = 200,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            cboDepreciationMethod.Items.AddRange({"StraightLine", "DecliningBalance"})
            cboDepreciationMethod.SelectedIndex = 0
            Me.Controls.Add(cboDepreciationMethod)
            yPos += 35

            ' Useful Life
            AddLabel("Useful Life (Years):", 20, yPos)
            txtUsefulLife = New TextBox() With {.Location = New Point(200, yPos), .Width = 100}
            Me.Controls.Add(txtUsefulLife)
            yPos += 35

            ' Salvage Value
            AddLabel("Salvage Value:", 20, yPos)
            txtSalvageValue = New TextBox() With {.Location = New Point(200, yPos), .Width = 150, .Text = "0"}
            Me.Controls.Add(txtSalvageValue)
            yPos += 35

            ' Asset Account
            AddLabel("Asset Account:", 20, yPos)
            cboAssetAccount = New ComboBox() With {
                .Location = New Point(200, yPos),
                .Width = 350,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            Me.Controls.Add(cboAssetAccount)
            yPos += 35

            ' Depreciation Account
            AddLabel("Depreciation Account:", 20, yPos)
            cboDepreciationAccount = New ComboBox() With {
                .Location = New Point(200, yPos),
                .Width = 350,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            Me.Controls.Add(cboDepreciationAccount)
            yPos += 35

            ' Expense Account
            AddLabel("Expense Account:", 20, yPos)
            cboExpenseAccount = New ComboBox() With {
                .Location = New Point(200, yPos),
                .Width = 350,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            Me.Controls.Add(cboExpenseAccount)
            yPos += 45

            ' Buttons
            btnSave = New Button() With {
                .Text = "Save",
                .Location = New Point(350, yPos),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat
            }
            AddHandler btnSave.Click, AddressOf BtnSave_Click
            Me.Controls.Add(btnSave)

            btnCancel = New Button() With {
                .Text = "Cancel",
                .Location = New Point(460, yPos),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat
            }
            AddHandler btnCancel.Click, AddressOf BtnCancel_Click
            Me.Controls.Add(btnCancel)
        End Sub

        Private Sub AddLabel(text As String, x As Integer, y As Integer)
            Dim lbl As New Label() With {
                .Text = text,
                .Location = New Point(x, y + 3),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            Me.Controls.Add(lbl)
        End Sub

        Private Sub LoadData()
            Try
                If String.IsNullOrEmpty(_connString) Then Return

                Using conn As New SqlConnection(_connString)
                    conn.Open()

                    ' Load Branches
                    Using cmd As New SqlCommand("SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName", conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cboBranch.Items.Add(New With {
                                    .BranchID = reader.GetInt32(0),
                                    .BranchName = reader.GetString(1),
                                    .Display = reader.GetString(1)
                                })
                            End While
                        End Using
                    End Using
                    cboBranch.DisplayMember = "Display"
                    cboBranch.ValueMember = "BranchID"
                    If cboBranch.Items.Count > 0 Then cboBranch.SelectedIndex = 0

                    ' Load Asset Accounts (1500-1599)
                    LoadAccounts(cboAssetAccount, "AccountCode LIKE '15%'")

                    ' Load Depreciation Accounts (1520-1599)
                    LoadAccounts(cboDepreciationAccount, "AccountCode LIKE '152%'")

                    ' Load Expense Accounts (6000-6999)
                    LoadAccounts(cboExpenseAccount, "AccountCode LIKE '6%'")
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadAccounts(combo As ComboBox, filter As String)
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand($"SELECT AccountID, AccountCode, AccountName FROM ChartOfAccounts WHERE IsActive = 1 AND {filter} ORDER BY AccountCode", conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                combo.Items.Add(New With {
                                    .AccountID = reader.GetInt32(0),
                                    .Display = $"{reader.GetString(1)} - {reader.GetString(2)}"
                                })
                            End While
                        End Using
                    End Using
                End Using
                combo.DisplayMember = "Display"
                combo.ValueMember = "AccountID"
                If combo.Items.Count > 0 Then combo.SelectedIndex = 0
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine($"Error loading accounts: {ex.Message}")
            End Try
        End Sub

        Private Sub BtnSave_Click(sender As Object, e As EventArgs)
            Try
                ' Validate
                If String.IsNullOrWhiteSpace(txtAssetCode.Text) Then
                    MessageBox.Show("Please enter asset code.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtAssetCode.Focus()
                    Return
                End If

                If String.IsNullOrWhiteSpace(txtAssetName.Text) Then
                    MessageBox.Show("Please enter asset name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtAssetName.Focus()
                    Return
                End If

                If cboCategory.SelectedIndex = -1 Then
                    MessageBox.Show("Please select category.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim purchasePrice As Decimal
                If Not Decimal.TryParse(txtPurchasePrice.Text, purchasePrice) OrElse purchasePrice <= 0 Then
                    MessageBox.Show("Please enter valid purchase price.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtPurchasePrice.Focus()
                    Return
                End If

                Dim usefulLife As Integer
                If Not Integer.TryParse(txtUsefulLife.Text, usefulLife) OrElse usefulLife <= 0 Then
                    MessageBox.Show("Please enter valid useful life in years.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtUsefulLife.Focus()
                    Return
                End If

                Dim salvageValue As Decimal
                If Not Decimal.TryParse(txtSalvageValue.Text, salvageValue) Then
                    salvageValue = 0
                End If

                ' Save
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_FixedAsset_Add", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@AssetCode", txtAssetCode.Text.Trim())
                        cmd.Parameters.AddWithValue("@AssetName", txtAssetName.Text.Trim())
                        cmd.Parameters.AddWithValue("@AssetCategory", cboCategory.SelectedItem.ToString())
                        cmd.Parameters.AddWithValue("@Description", If(String.IsNullOrWhiteSpace(txtDescription.Text), DBNull.Value, CObj(txtDescription.Text.Trim())))
                        cmd.Parameters.AddWithValue("@PurchaseDate", dtpPurchaseDate.Value.Date)
                        cmd.Parameters.AddWithValue("@PurchasePrice", purchasePrice)
                        cmd.Parameters.AddWithValue("@SupplierID", DBNull.Value)
                        cmd.Parameters.AddWithValue("@InvoiceNumber", DBNull.Value)
                        cmd.Parameters.AddWithValue("@BranchID", CInt(cboBranch.SelectedItem.BranchID))
                        cmd.Parameters.AddWithValue("@LocationDetails", If(String.IsNullOrWhiteSpace(txtLocation.Text), DBNull.Value, CObj(txtLocation.Text.Trim())))
                        cmd.Parameters.AddWithValue("@SerialNumber", If(String.IsNullOrWhiteSpace(txtSerialNumber.Text), DBNull.Value, CObj(txtSerialNumber.Text.Trim())))
                        cmd.Parameters.AddWithValue("@DepreciationMethod", cboDepreciationMethod.SelectedItem.ToString())
                        cmd.Parameters.AddWithValue("@UsefulLifeYears", usefulLife)
                        cmd.Parameters.AddWithValue("@SalvageValue", salvageValue)
                        cmd.Parameters.AddWithValue("@AssetAccountID", CInt(cboAssetAccount.SelectedItem.AccountID))
                        cmd.Parameters.AddWithValue("@DepreciationAccountID", CInt(cboDepreciationAccount.SelectedItem.AccountID))
                        cmd.Parameters.AddWithValue("@ExpenseAccountID", CInt(cboExpenseAccount.SelectedItem.AccountID))
                        cmd.Parameters.AddWithValue("@CreatedBy", 1) ' TODO: Use actual user ID
                        
                        Dim assetIDParam As New SqlParameter("@AssetID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                        cmd.Parameters.Add(assetIDParam)

                        cmd.ExecuteNonQuery()

                        MessageBox.Show($"Asset added successfully! Asset ID: {assetIDParam.Value}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Me.DialogResult = DialogResult.OK
                        Me.Close()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error saving asset: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub
    End Class
End Namespace
