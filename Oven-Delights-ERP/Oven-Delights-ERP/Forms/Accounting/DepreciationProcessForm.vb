Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class DepreciationProcessForm
        Inherits Form

        Private dtpDepreciationPeriod As DateTimePicker
        Private chkPostToGL As CheckBox
        Private lblInfo As Label
        Private btnProcess As Button
        Private btnCancel As Button
        Private txtResults As TextBox
        Private _connString As String

        Public Sub New()
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Process Monthly Depreciation"
            Me.Size = New Size(600, 500)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White

            Dim yPos As Integer = 20

            ' Title
            Dim lblTitle As New Label() With {
                .Text = "Monthly Depreciation Processing",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            Me.Controls.Add(lblTitle)
            yPos += 40

            ' Info Panel
            Dim pnlInfo As New Panel() With {
                .Location = New Point(20, yPos),
                .Size = New Size(540, 100),
                .BackColor = Color.FromArgb(241, 196, 15),
                .BorderStyle = BorderStyle.FixedSingle
            }

            lblInfo = New Label() With {
                .Location = New Point(10, 10),
                .Size = New Size(520, 80),
                .Font = New Font("Segoe UI", 9),
                .Text = "ℹ️ This process will calculate and record depreciation for all active fixed assets " &
                       "for the selected period. If 'Post to GL' is checked, journal entries will be " &
                       "automatically created with:" & vbCrLf &
                       "  • DR Depreciation Expense" & vbCrLf &
                       "  • CR Accumulated Depreciation"
            }
            pnlInfo.Controls.Add(lblInfo)
            Me.Controls.Add(pnlInfo)
            yPos += 120

            ' Depreciation Period
            Dim lblPeriod As New Label() With {
                .Text = "Depreciation Period (Month End):",
                .Location = New Point(20, yPos + 3),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            Me.Controls.Add(lblPeriod)

            dtpDepreciationPeriod = New DateTimePicker() With {
                .Location = New Point(250, yPos),
                .Width = 200,
                .Format = DateTimePickerFormat.Short,
                .Value = New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month))
            }
            Me.Controls.Add(dtpDepreciationPeriod)
            yPos += 40

            ' Post to GL
            chkPostToGL = New CheckBox() With {
                .Text = "Post depreciation entries to General Ledger",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Checked = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            Me.Controls.Add(chkPostToGL)
            yPos += 40

            ' Results
            Dim lblResults As New Label() With {
                .Text = "Processing Results:",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            Me.Controls.Add(lblResults)
            yPos += 25

            txtResults = New TextBox() With {
                .Location = New Point(20, yPos),
                .Size = New Size(540, 100),
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .ReadOnly = True,
                .BackColor = Color.White,
                .Font = New Font("Consolas", 9)
            }
            Me.Controls.Add(txtResults)
            yPos += 120

            ' Buttons
            btnProcess = New Button() With {
                .Text = "Process Depreciation",
                .Location = New Point(350, yPos),
                .Size = New Size(140, 35),
                .BackColor = Color.FromArgb(155, 89, 182),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            AddHandler btnProcess.Click, AddressOf BtnProcess_Click
            Me.Controls.Add(btnProcess)

            btnCancel = New Button() With {
                .Text = "Close",
                .Location = New Point(500, yPos),
                .Size = New Size(60, 35),
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat
            }
            AddHandler btnCancel.Click, AddressOf BtnCancel_Click
            Me.Controls.Add(btnCancel)
        End Sub

        Private Sub BtnProcess_Click(sender As Object, e As EventArgs)
            Try
                ' Validate period is month-end
                Dim selectedDate = dtpDepreciationPeriod.Value.Date
                Dim lastDayOfMonth = New DateTime(selectedDate.Year, selectedDate.Month, DateTime.DaysInMonth(selectedDate.Year, selectedDate.Month))

                If selectedDate <> lastDayOfMonth Then
                    Dim result = MessageBox.Show(
                        $"The selected date ({selectedDate:yyyy-MM-dd}) is not the last day of the month.{vbCrLf}{vbCrLf}" &
                        $"Depreciation should typically be processed on month-end: {lastDayOfMonth:yyyy-MM-dd}{vbCrLf}{vbCrLf}" &
                        "Do you want to continue anyway?",
                        "Month-End Warning",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Warning
                    )

                    If result <> DialogResult.Yes Then Return
                End If

                ' Confirm
                Dim confirmResult = MessageBox.Show(
                    $"Process depreciation for period: {selectedDate:yyyy-MM-dd}?{vbCrLf}{vbCrLf}" &
                    $"Post to GL: {If(chkPostToGL.Checked, "Yes", "No")}{vbCrLf}{vbCrLf}" &
                    "This will calculate depreciation for all active assets.",
                    "Confirm Processing",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question
                )

                If confirmResult <> DialogResult.Yes Then Return

                ' Disable button during processing
                btnProcess.Enabled = False
                txtResults.Text = "Processing depreciation..." & vbCrLf
                Me.Cursor = Cursors.WaitCursor
                Application.DoEvents()

                ' Process
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_FixedAsset_ProcessDepreciation", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.CommandTimeout = 120 ' 2 minutes for large asset lists
                        cmd.Parameters.AddWithValue("@DepreciationPeriod", selectedDate)
                        cmd.Parameters.AddWithValue("@PostToGL", chkPostToGL.Checked)
                        cmd.Parameters.AddWithValue("@ProcessedBy", 1) ' TODO: Use actual user ID

                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                Dim assetsProcessed = reader.GetInt32(0)
                                Dim totalDepreciation = reader.GetDecimal(1)
                                Dim message = reader.GetString(2)

                                txtResults.Text = "✓ DEPRECIATION PROCESSING COMPLETE" & vbCrLf & vbCrLf &
                                                 $"Period: {selectedDate:yyyy-MM-dd}" & vbCrLf &
                                                 $"Assets Processed: {assetsProcessed}" & vbCrLf &
                                                 $"Total Depreciation: R{totalDepreciation:N2}" & vbCrLf &
                                                 $"Posted to GL: {If(chkPostToGL.Checked, "Yes", "No")}" & vbCrLf & vbCrLf &
                                                 message

                                MessageBox.Show(
                                    $"Depreciation processed successfully!{vbCrLf}{vbCrLf}" &
                                    $"Assets: {assetsProcessed}{vbCrLf}" &
                                    $"Total: R{totalDepreciation:N2}",
                                    "Success",
                                    MessageBoxButtons.OK,
                                    MessageBoxIcon.Information
                                )

                                Me.DialogResult = DialogResult.OK
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                txtResults.Text &= vbCrLf & vbCrLf & "✗ ERROR:" & vbCrLf & ex.Message
                MessageBox.Show($"Error processing depreciation: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Finally
                btnProcess.Enabled = True
                Me.Cursor = Cursors.Default
            End Try
        End Sub

        Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
            Me.Close()
        End Sub
    End Class
End Namespace
