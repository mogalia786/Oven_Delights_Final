Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class FixedAssetDisposeForm
        Inherits Form

        Private ReadOnly _assetID As Integer
        Private ReadOnly _assetName As String
        Private dtpDisposalDate As DateTimePicker
        Private txtDisposalAmount As TextBox
        Private txtDisposalNotes As TextBox
        Private chkPostToGL As CheckBox
        Private btnDispose As Button
        Private btnCancel As Button
        Private lblAssetInfo As Label
        Private _connString As String

        Public Sub New(assetID As Integer, assetName As String)
            _assetID = assetID
            _assetName = assetName
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            LoadAssetInfo()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Dispose Fixed Asset"
            Me.Size = New Size(500, 450)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White

            Dim yPos As Integer = 20

            ' Asset Info Panel
            Dim pnlInfo As New Panel() With {
                .Location = New Point(20, yPos),
                .Size = New Size(440, 80),
                .BackColor = Color.FromArgb(236, 240, 241),
                .BorderStyle = BorderStyle.FixedSingle
            }

            lblAssetInfo = New Label() With {
                .Location = New Point(10, 10),
                .Size = New Size(420, 60),
                .Font = New Font("Segoe UI", 9),
                .Text = "Loading asset information..."
            }
            pnlInfo.Controls.Add(lblAssetInfo)
            Me.Controls.Add(pnlInfo)
            yPos += 100

            ' Disposal Date
            AddLabel("Disposal Date:", 20, yPos)
            dtpDisposalDate = New DateTimePicker() With {
                .Location = New Point(180, yPos),
                .Width = 200,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Now
            }
            Me.Controls.Add(dtpDisposalDate)
            yPos += 40

            ' Disposal Amount
            AddLabel("Disposal Amount (R):", 20, yPos)
            txtDisposalAmount = New TextBox() With {
                .Location = New Point(180, yPos),
                .Width = 150,
                .Text = "0.00"
            }
            Me.Controls.Add(txtDisposalAmount)
            yPos += 40

            ' Disposal Notes
            AddLabel("Notes:", 20, yPos)
            txtDisposalNotes = New TextBox() With {
                .Location = New Point(180, yPos),
                .Size = New Size(280, 80),
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical
            }
            Me.Controls.Add(txtDisposalNotes)
            yPos += 100

            ' Post to GL
            chkPostToGL = New CheckBox() With {
                .Text = "Post disposal entry to General Ledger",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Checked = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            Me.Controls.Add(chkPostToGL)
            yPos += 40

            ' Warning Label
            Dim lblWarning As New Label() With {
                .Text = "⚠️ Warning: This action cannot be undone!",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .ForeColor = Color.FromArgb(231, 76, 60),
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            Me.Controls.Add(lblWarning)
            yPos += 35

            ' Buttons
            btnDispose = New Button() With {
                .Text = "Dispose Asset",
                .Location = New Point(250, yPos),
                .Size = New Size(120, 35),
                .BackColor = Color.FromArgb(231, 76, 60),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            AddHandler btnDispose.Click, AddressOf BtnDispose_Click
            Me.Controls.Add(btnDispose)

            btnCancel = New Button() With {
                .Text = "Cancel",
                .Location = New Point(380, yPos),
                .Size = New Size(80, 35),
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

        Private Sub LoadAssetInfo()
            Try
                If String.IsNullOrEmpty(_connString) Then Return

                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("SELECT AssetCode, PurchaseDate, PurchasePrice, CurrentBookValue, AccumulatedDepreciation FROM FixedAssets WHERE AssetID = @AssetID", conn)
                        cmd.Parameters.AddWithValue("@AssetID", _assetID)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                Dim assetCode = reader.GetString(0)
                                Dim purchaseDate = reader.GetDateTime(1)
                                Dim purchasePrice = reader.GetDecimal(2)
                                Dim bookValue = reader.GetDecimal(3)
                                Dim accumDep = reader.GetDecimal(4)

                                lblAssetInfo.Text = $"Asset: {_assetName} ({assetCode}){vbCrLf}" &
                                                   $"Purchase Date: {purchaseDate:yyyy-MM-dd} | Cost: R{purchasePrice:N2}{vbCrLf}" &
                                                   $"Book Value: R{bookValue:N2} | Accumulated Depreciation: R{accumDep:N2}"
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                lblAssetInfo.Text = $"Error loading asset info: {ex.Message}"
            End Try
        End Sub

        Private Sub BtnDispose_Click(sender As Object, e As EventArgs)
            Try
                ' Validate
                Dim disposalAmount As Decimal
                If Not Decimal.TryParse(txtDisposalAmount.Text, disposalAmount) OrElse disposalAmount < 0 Then
                    MessageBox.Show("Please enter a valid disposal amount (0 or greater).", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtDisposalAmount.Focus()
                    Return
                End If

                ' Confirm
                Dim result = MessageBox.Show(
                    $"Are you sure you want to dispose of this asset?{vbCrLf}{vbCrLf}" &
                    $"Asset: {_assetName}{vbCrLf}" &
                    $"Disposal Amount: R{disposalAmount:N2}{vbCrLf}" &
                    $"Post to GL: {If(chkPostToGL.Checked, "Yes", "No")}{vbCrLf}{vbCrLf}" &
                    "This action cannot be undone!",
                    "Confirm Disposal",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Warning
                )

                If result <> DialogResult.Yes Then Return

                ' Dispose
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_FixedAsset_Dispose", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@AssetID", _assetID)
                        cmd.Parameters.AddWithValue("@DisposalDate", dtpDisposalDate.Value.Date)
                        cmd.Parameters.AddWithValue("@DisposalAmount", disposalAmount)
                        cmd.Parameters.AddWithValue("@DisposalNotes", If(String.IsNullOrWhiteSpace(txtDisposalNotes.Text), DBNull.Value, CObj(txtDisposalNotes.Text.Trim())))
                        cmd.Parameters.AddWithValue("@PostToGL", chkPostToGL.Checked)
                        cmd.Parameters.AddWithValue("@DisposedBy", 1) ' TODO: Use actual user ID

                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                Dim gainLoss = reader.GetDecimal(1)
                                Dim gainLossType = reader.GetString(2)
                                Dim message = reader.GetString(3)

                                MessageBox.Show(
                                    $"{message}{vbCrLf}{vbCrLf}" &
                                    $"{gainLossType}: R{Math.Abs(gainLoss):N2}",
                                    "Disposal Complete",
                                    MessageBoxButtons.OK,
                                    MessageBoxIcon.Information
                                )
                            End If
                        End Using
                    End Using
                End Using

                Me.DialogResult = DialogResult.OK
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error disposing asset: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub
    End Class
End Namespace
