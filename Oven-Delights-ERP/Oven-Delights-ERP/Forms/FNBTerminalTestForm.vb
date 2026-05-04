Imports System.Threading.Tasks

Public Class FNBTerminalTestForm
    Private testService As New FNBTerminalTestService()
    Private lastReconIndicator As String

    Private Sub FNBTerminalTestForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "FNB POS Terminal - Sandbox Test Lab"
        Me.Size = New Size(900, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        InitializeControls()
        AddHandler btnTestConnection.Click, AddressOf TestConnection
        AddHandler btnSendTransaction.Click, AddressOf SendTransaction
        AddHandler btnCheckStatus.Click, AddressOf CheckStatus
        AddHandler btnCancelTransaction.Click, AddressOf CancelTransaction
        AddHandler btnClearLog.Click, AddressOf ClearLog
    End Sub

    Private Sub InitializeControls()
        Dim grpConfig As New GroupBox With {
            .Text = "Sandbox Configuration",
            .Location = New Point(10, 10),
            .Size = New Size(860, 180)
        }

        Dim lblInfo As New Label With {
            .Text = "Environment: FNB Test Lab (https://test.figment.co.za:49410/api/)" & vbCrLf &
                    "Site ID: UT02 | Terminal 10: Virtual (Auto-Approved) | Terminal 7: Real PED (Requires Card Swipe)" & vbCrLf &
                    "OAuth Client ID: MP7BQIe0TMxgxzhpGghkNF303zhmYnjA",
            .Location = New Point(10, 20),
            .Size = New Size(840, 50),
            .Font = New Font("Segoe UI", 9, FontStyle.Regular)
        }

        ' Terminal Mode Selection
        Dim lblMode As New Label With {
            .Text = "Terminal Mode:",
            .Location = New Point(10, 75),
            .Size = New Size(100, 20),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }

        rdoUnattended = New RadioButton With {
            .Text = "Unattended (Terminal 10 - Virtual Auto-Approved)",
            .Location = New Point(120, 75),
            .Size = New Size(320, 20),
            .Checked = True,
            .Font = New Font("Segoe UI", 9)
        }

        rdoAttended = New RadioButton With {
            .Text = "Attended (Terminal 7 - Real PED Requires Card Swipe)",
            .Location = New Point(450, 75),
            .Size = New Size(380, 20),
            .ForeColor = Color.FromArgb(255, 140, 0),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }

        lblModeInfo = New Label With {
            .Text = "Mode: Unattended - Terminal 10 (Virtual) - Auto-approved, no physical card required",
            .Location = New Point(120, 100),
            .Size = New Size(720, 35),
            .Font = New Font("Segoe UI", 8, FontStyle.Italic),
            .ForeColor = Color.Blue
        }

        AddHandler rdoUnattended.CheckedChanged, Sub()
            If rdoUnattended.Checked Then
                lblModeInfo.Text = "Mode: Unattended - Terminal 10 (Virtual) - Auto-approved, no physical card required"
                lblModeInfo.ForeColor = Color.Blue
            End If
        End Sub

        AddHandler rdoAttended.CheckedChanged, Sub()
            If rdoAttended.Checked Then
                lblModeInfo.Text = "Mode: Attended - Terminal 7 (Real PED) - FNB agent must swipe actual card at physical terminal"
                lblModeInfo.ForeColor = Color.FromArgb(255, 140, 0)
            End If
        End Sub

        btnTestConnection = New Button With {
            .Text = "Test API Connection",
            .Location = New Point(10, 145),
            .Size = New Size(150, 30),
            .BackColor = Color.FromArgb(0, 122, 204),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }

        grpConfig.Controls.AddRange({lblInfo, lblMode, rdoUnattended, rdoAttended, lblModeInfo, btnTestConnection})

        Dim grpTransaction As New GroupBox With {
            .Text = "Test Transaction",
            .Location = New Point(10, 200),
            .Size = New Size(860, 140)
        }

        Dim lblAmount As New Label With {
            .Text = "Amount (R):",
            .Location = New Point(10, 25),
            .Size = New Size(80, 20)
        }

        txtAmount = New TextBox With {
            .Location = New Point(100, 23),
            .Size = New Size(100, 23),
            .Text = "10.00"
        }

        Dim lblOperator As New Label With {
            .Text = "Operator:",
            .Location = New Point(220, 25),
            .Size = New Size(60, 20)
        }

        txtOperator = New TextBox With {
            .Location = New Point(290, 23),
            .Size = New Size(150, 23),
            .Text = "Test Cashier"
        }

        Dim lblSlip As New Label With {
            .Text = "Slip No:",
            .Location = New Point(460, 25),
            .Size = New Size(60, 20)
        }

        txtSlipNo = New TextBox With {
            .Location = New Point(530, 23),
            .Size = New Size(80, 23),
            .Text = "1"
        }

        ' Transaction Type Selection
        Dim lblTransType As New Label With {
            .Text = "Type:",
            .Location = New Point(630, 25),
            .Size = New Size(40, 20),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }

        rdoSale = New RadioButton With {
            .Text = "Sale",
            .Location = New Point(680, 23),
            .Size = New Size(60, 20),
            .Checked = True,
            .Font = New Font("Segoe UI", 9)
        }

        rdoRefund = New RadioButton With {
            .Text = "Refund",
            .Location = New Point(750, 23),
            .Size = New Size(80, 20),
            .ForeColor = Color.FromArgb(192, 0, 0),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }

        btnSendTransaction = New Button With {
            .Text = "Send Transaction to Terminal",
            .Location = New Point(10, 60),
            .Size = New Size(200, 35),
            .BackColor = Color.FromArgb(0, 176, 80),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }

        btnCheckStatus = New Button With {
            .Text = "Check Status",
            .Location = New Point(220, 60),
            .Size = New Size(120, 35),
            .BackColor = Color.FromArgb(255, 192, 0),
            .ForeColor = Color.Black,
            .FlatStyle = FlatStyle.Flat
        }

        btnCancelTransaction = New Button With {
            .Text = "Cancel",
            .Location = New Point(350, 60),
            .Size = New Size(100, 35),
            .BackColor = Color.FromArgb(192, 0, 0),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }

        lblStatus = New Label With {
            .Text = "Status: Ready",
            .Location = New Point(10, 105),
            .Size = New Size(840, 25),
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .ForeColor = Color.Blue
        }

        grpTransaction.Controls.AddRange({lblAmount, txtAmount, lblOperator, txtOperator,
                                          lblSlip, txtSlipNo, lblTransType, rdoSale, rdoRefund,
                                          btnSendTransaction, btnCheckStatus, btnCancelTransaction, lblStatus})

        Dim grpResults As New GroupBox With {
            .Text = "Test Results & Response Log",
            .Location = New Point(10, 350),
            .Size = New Size(860, 290)
        }

        txtLog = New TextBox With {
            .Location = New Point(10, 25),
            .Size = New Size(840, 220),
            .Multiline = True,
            .ScrollBars = ScrollBars.Vertical,
            .Font = New Font("Consolas", 9),
            .ReadOnly = True,
            .BackColor = Color.Black,
            .ForeColor = Color.Lime
        }

        btnClearLog = New Button With {
            .Text = "Clear Log",
            .Location = New Point(10, 250),
            .Size = New Size(100, 30)
        }

        grpResults.Controls.AddRange({txtLog, btnClearLog})

        Me.Controls.AddRange({grpConfig, grpTransaction, grpResults})
    End Sub

    Private btnTestConnection As Button
    Private btnSendTransaction As Button
    Private btnCheckStatus As Button
    Private btnCancelTransaction As Button
    Private btnClearLog As Button
    Private txtAmount As TextBox
    Private txtOperator As TextBox
    Private txtSlipNo As TextBox
    Private txtLog As TextBox
    Private lblStatus As Label
    Private rdoUnattended As RadioButton
    Private rdoAttended As RadioButton
    Private lblModeInfo As Label
    Private rdoSale As RadioButton
    Private rdoRefund As RadioButton

    Private Async Sub TestConnection(sender As Object, e As EventArgs)
        Try
            btnTestConnection.Enabled = False
            lblStatus.Text = "Status: Testing API connection..."
            lblStatus.ForeColor = Color.Blue
            LogMessage("=== Testing API Connection ===")

            Dim result = Await testService.TestAPIStatus()

            If result.Success Then
                lblStatus.Text = "Status: API Connected ✓"
                lblStatus.ForeColor = Color.Green
                LogMessage("✓ API is online and responding", Color.Green)
                LogMessage($"Response: {result.RawResponse}")
            Else
                lblStatus.Text = "Status: API Connection Failed ✗"
                lblStatus.ForeColor = Color.Red
                LogMessage("✗ API connection failed", Color.Red)
                LogMessage($"Error: {result.Message}")
            End If

        Catch ex As Exception
            lblStatus.Text = "Status: Error"
            lblStatus.ForeColor = Color.Red
            LogMessage($"✗ Exception: {ex.Message}", Color.Red)
        Finally
            btnTestConnection.Enabled = True
        End Try
    End Sub

    Private Async Sub SendTransaction(sender As Object, e As EventArgs)
        Try
            Dim amount As Decimal
            If Not Decimal.TryParse(txtAmount.Text, amount) OrElse amount <= 0 Then
                MessageBox.Show("Please enter a valid amount greater than 0", "Invalid Amount", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim slipNo As Integer
            If Not Integer.TryParse(txtSlipNo.Text, slipNo) Then
                slipNo = 1
            End If

            btnSendTransaction.Enabled = False
            lblStatus.Text = "Status: Sending transaction to terminal..."
            lblStatus.ForeColor = Color.Blue

            ' Determine terminal ID based on selected mode
            Dim terminalId As Integer = If(rdoAttended.Checked, 7, 10)
            Dim terminalMode = If(rdoAttended.Checked, "ATTENDED (Real PED - Terminal 7)", "UNATTENDED (Virtual - Terminal 10)")
            
            ' Determine transaction type based on selected radio button
            Dim transactionType As String = If(rdoRefund.Checked, "Refund", "Settlement")
            
            ' Set the terminal ID in the service
            testService.SetTerminalId(terminalId)
            
            LogMessage("=== Sending Transaction to FNB Terminal ===")
            LogMessage($"Transaction Type: {transactionType}")
            LogMessage($"Terminal Mode: {terminalMode}")
            LogMessage($"Terminal ID: {terminalId}")
            If rdoAttended.Checked Then
                LogMessage("⚠️ ATTENDED MODE: FNB agent must swipe actual card at physical terminal 7", Color.Yellow)
            Else
                LogMessage("✓ UNATTENDED MODE: Virtual terminal 10 will auto-approve", Color.Lime)
            End If
            LogMessage("")

            Dim result = Await testService.ProcessTestTransaction(amount, txtOperator.Text, 1, slipNo, transactionType, AddressOf LogMessage)

            If result.Success Then
                lblStatus.Text = "Status: Transaction APPROVED ✓"
                lblStatus.ForeColor = Color.Green
                LogMessage("✓✓✓ TRANSACTION APPROVED ✓✓✓", Color.Green)
                LogMessage($"Result Code: {result.ResultCode}")
                LogMessage($"Approval Code: {result.ApprovalCode}")
                LogMessage($"Card Type: {result.CardType}")
                LogMessage($"Masked PAN: {result.MaskedPAN}")
                LogMessage($"Transaction UTI: {result.TransactionUTI}")
                LogMessage($"Merchant Number: {result.MerchantNumber}")
                LogMessage($"Terminal ID: {result.TerminalId}")
                LogMessage("--- Full Response ---")
                LogMessage(result.RawResponse)
            Else
                lblStatus.Text = $"Status: {result.Message}"
                lblStatus.ForeColor = Color.Red
                LogMessage($"✗✗✗ TRANSACTION FAILED ✗✗✗", Color.Red)
                LogMessage($"Message: {result.Message}")
                LogMessage($"Result Code: {result.ResultCode}")
                LogMessage("--- Full Response ---")
                LogMessage(result.RawResponse)
            End If

        Catch ex As Exception
            lblStatus.Text = "Status: Error"
            lblStatus.ForeColor = Color.Red
            LogMessage($"✗ Exception: {ex.Message}", Color.Red)
        Finally
            btnSendTransaction.Enabled = True
        End Try
    End Sub

    Private Async Sub CheckStatus(sender As Object, e As EventArgs)
        Try
            If String.IsNullOrEmpty(lastReconIndicator) Then
                MessageBox.Show("No transaction to check. Send a transaction first.", "No Transaction", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            btnCheckStatus.Enabled = False
            LogMessage("=== Checking Transaction Status ===")
            LogMessage($"Recon Indicator: {lastReconIndicator}")

            Dim result = Await testService.GetTransactionStatus(lastReconIndicator)

            If result.Success Then
                LogMessage("✓ Status retrieved successfully", Color.Green)
                LogMessage(result.RawResponse)
            Else
                LogMessage("✗ Status check failed", Color.Red)
                LogMessage(result.Message)
            End If

        Catch ex As Exception
            LogMessage($"✗ Exception: {ex.Message}", Color.Red)
        Finally
            btnCheckStatus.Enabled = True
        End Try
    End Sub

    Private Async Sub CancelTransaction(sender As Object, e As EventArgs)
        Try
            If String.IsNullOrEmpty(lastReconIndicator) Then
                MessageBox.Show("No transaction to cancel. Send a transaction first.", "No Transaction", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            btnCancelTransaction.Enabled = False
            LogMessage("=== Cancelling Transaction ===")
            LogMessage($"Recon Indicator: {lastReconIndicator}")

            Dim result = Await testService.CancelTransaction(lastReconIndicator)

            If result.Success Then
                LogMessage("✓ Transaction cancelled successfully", Color.Green)
                LogMessage(result.RawResponse)
            Else
                LogMessage("✗ Cancellation failed", Color.Red)
                LogMessage(result.Message)
            End If

        Catch ex As Exception
            LogMessage($"✗ Exception: {ex.Message}", Color.Red)
        Finally
            btnCancelTransaction.Enabled = True
        End Try
    End Sub

    Private Sub ClearLog(sender As Object, e As EventArgs)
        txtLog.Clear()
        LogMessage("Log cleared - Ready for new tests")
    End Sub

    Private Sub LogMessage(message As String, Optional color As Color = Nothing)
        If color = Nothing Then color = Color.Lime

        Dim timestamp = DateTime.Now.ToString("HH:mm:ss")
        txtLog.AppendText($"[{timestamp}] {message}{vbCrLf}")
        txtLog.SelectionStart = txtLog.Text.Length
        txtLog.ScrollToCaret()
    End Sub
End Class
