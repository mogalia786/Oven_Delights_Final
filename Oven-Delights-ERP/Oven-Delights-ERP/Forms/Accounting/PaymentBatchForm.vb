Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class PaymentBatchForm
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private tabControl As TabControl
    Private txtTestResults As TextBox
    Private txtResponseLog As TextBox
    Private btnClearLog As Button

    Private Sub PaymentBatchForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Super Admin can choose bank/format for any branch; others are locked by branch rule elsewhere when posting
            cboBank.SelectedIndex = 0
            cboFormat.SelectedIndex = 1 ' CSV by default
            CreateStatusLogControl()
        Catch ex As Exception
            MessageBox.Show($"Error initializing Payment Batch: {ex.Message}")
        End Try
    End Sub

    Private Sub CreateStatusLogControl()
        Try
            ' Create TabControl on LEFT side of form
            tabControl = New TabControl With {
                .Location = New Point(12, 42),
                .Size = New Size(400, Me.ClientSize.Height - 92),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left,
                .Visible = True
            }
            
            ' Test Results Tab
            Dim tabTestResults As New TabPage("Test Results")
            txtTestResults = New TextBox With {
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .ReadOnly = True,
                .Font = New Font("Consolas", 9),
                .BackColor = Color.Black,
                .ForeColor = Color.Lime,
                .Dock = DockStyle.Fill
            }
            tabTestResults.Controls.Add(txtTestResults)
            
            ' Response Log Tab
            Dim tabResponseLog As New TabPage("Response Log")
            txtResponseLog = New TextBox With {
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .ReadOnly = True,
                .Font = New Font("Consolas", 9),
                .BackColor = Color.Black,
                .ForeColor = Color.Lime,
                .Dock = DockStyle.Fill
            }
            tabResponseLog.Controls.Add(txtResponseLog)
            
            tabControl.TabPages.Add(tabTestResults)
            tabControl.TabPages.Add(tabResponseLog)
            Me.Controls.Add(tabControl)
            tabControl.BringToFront()
            
            ' Clear Log button
            btnClearLog = New Button With {
                .Text = "Clear Log",
                .Location = New Point(12, Me.ClientSize.Height - 42),
                .Size = New Size(100, 30),
                .Anchor = AnchorStyles.Bottom Or AnchorStyles.Left,
                .Visible = True
            }
            AddHandler btnClearLog.Click, AddressOf ClearLog_Click
            Me.Controls.Add(btnClearLog)
            btnClearLog.BringToFront()
            
            ' Adjust dgv to be on the right side
            If dgv IsNot Nothing Then
                dgv.Location = New Point(420, 42)
                dgv.Size = New Size(Me.ClientSize.Width - 432, Me.ClientSize.Height - 54)
                dgv.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
            End If
            
            ' Force refresh
            Me.Refresh()
        Catch ex As Exception
            MessageBox.Show($"Error creating status log controls: {ex.Message}{Environment.NewLine}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ClearLog_Click(sender As Object, e As EventArgs)
        txtTestResults.Clear()
        txtResponseLog.Clear()
    End Sub

    Private Sub LogMessage(message As String)
        If txtTestResults.InvokeRequired Then
            txtTestResults.Invoke(Sub() LogMessage(message))
        Else
            Dim timestamp = DateTime.Now.ToString("HH:mm:ss")
            txtTestResults.AppendText($"[{timestamp}] {message}" & Environment.NewLine)
            txtTestResults.SelectionStart = txtTestResults.Text.Length
            txtTestResults.ScrollToCaret()
        End If
    End Sub
    
    Private Sub LogResponse(message As String)
        If txtResponseLog.InvokeRequired Then
            txtResponseLog.Invoke(Sub() LogResponse(message))
        Else
            Dim timestamp = DateTime.Now.ToString("HH:mm:ss")
            txtResponseLog.AppendText($"[{timestamp}] {message}" & Environment.NewLine)
            txtResponseLog.SelectionStart = txtResponseLog.Text.Length
            txtResponseLog.ScrollToCaret()
        End If
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        Try
            ' Load suppliers with bank details from database
            Dim dt As New DataTable()
            dt.Columns.Add("SupplierID", GetType(Integer))
            dt.Columns.Add("PayeeName")
            dt.Columns.Add("DocType")
            dt.Columns.Add("DocNo")
            dt.Columns.Add("DueDate", GetType(Date))
            dt.Columns.Add("Amount", GetType(Decimal))
            dt.Columns.Add("MyReference")
            dt.Columns.Add("BeneficiaryReference")
            dt.Columns.Add("AccountNumber")
            dt.Columns.Add("BranchCode")
            dt.Columns.Add("BankName")
            dt.Columns.Add("Email")
            
            ' Load test suppliers with sandbox bank details
            Using conn As New SqlConnection(_connectionString)
                Dim sql = "SELECT SupplierID, CompanyName, BankAccountNumber, BankBranchCode, BankName, ProofOfPaymentEmail " &
                          "FROM Suppliers WHERE IsActive = 1 AND BankAccountNumber IS NOT NULL ORDER BY CompanyName"
                Using cmd As New SqlCommand(sql, conn)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim supplierId = CInt(reader("SupplierID"))
                            Dim supplierName = reader("CompanyName").ToString()
                            Dim accountNumber = reader("BankAccountNumber").ToString()
                            Dim branchCode = reader("BankBranchCode").ToString()
                            Dim bankName = If(reader("BankName") Is DBNull.Value, "FNB", reader("BankName").ToString())
                            Dim email = If(reader("ProofOfPaymentEmail") Is DBNull.Value, "", reader("ProofOfPaymentEmail").ToString())
                            
                            ' Add sample invoice for this supplier
                            dt.Rows.Add(
                                supplierId,
                                supplierName,
                                "Supplier Payment",
                                $"INV-{supplierId:D5}",
                                Date.Today.AddDays(7),
                                1000.0D + (supplierId * 100),
                                $"PAY-{Date.Today:yyyyMMdd}-{supplierId:D3}",
                                $"INV-{supplierId:D5}",
                                accountNumber,
                                branchCode,
                                bankName,
                                email
                            )
                        End While
                    End Using
                End Using
            End Using
            
            dgv.DataSource = dt
            
            ' Hide SupplierID column
            If dgv.Columns.Contains("SupplierID") Then
                dgv.Columns("SupplierID").Visible = False
            End If
            
            MessageBox.Show($"Loaded {dt.Rows.Count} payment(s) from suppliers with bank details.", "Load Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error loading payables: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnValidate_Click(sender As Object, e As EventArgs) Handles btnValidate.Click
        Try
            If dgv.DataSource Is Nothing Then
                MessageBox.Show("Load items first.")
                Return
            End If
            Dim bank = If(cboBank.SelectedItem, "").ToString()
            Dim fmt = If(cboFormat.SelectedItem, "").ToString()
            Dim ok = ValidateForBank(bank)
            If ok Then
                MessageBox.Show($"Validated for {bank} ({fmt}).")
            Else
                MessageBox.Show($"Validation failed for {bank}. Please review highlighted rows.")
            End If
        Catch ex As Exception
            MessageBox.Show($"Validation error: {ex.Message}")
        End Try
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            If dgv.DataSource Is Nothing Then
                MessageBox.Show("Load items first.")
                Return
            End If
            Dim bank = If(cboBank.SelectedItem, "").ToString()
            Dim fmt = If(cboFormat.SelectedItem, "").ToString()
            Dim path = ExportForBank(bank, fmt)
            If Not String.IsNullOrWhiteSpace(path) Then
                MessageBox.Show($"Exported {fmt} for {bank} to:{Environment.NewLine}{path}")
            Else
                MessageBox.Show($"Export failed for {bank} ({fmt}).")
            End If
        Catch ex As Exception
            MessageBox.Show($"Export error: {ex.Message}")
        End Try
    End Sub

    Private Sub btnPost_Click(sender As Object, e As EventArgs) Handles btnPost.Click
        Try
            If dgv.DataSource Is Nothing Then
                MessageBox.Show("Load items first.")
                Return
            End If
            ' Validate before posting
            Dim bank = If(cboBank.SelectedItem, "").ToString()
            If Not ValidateForBank(bank) Then
                MessageBox.Show($"Validation failed for {bank}. Fix highlighted rows before posting.")
                Return
            End If

            Dim svc As New AccountingPostingService()
            Dim createdBy As Integer = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.UserID, 0)
            Dim branchId As Integer = AppSession.CurrentBranchID
            Dim postedCount As Integer = 0
            Dim errors As New List(Of String)()
            Dim remittance As New List(Of String)()
            remittance.Add("Payee,DocType,DocNo,Amount,MyReference,BeneficiaryReference,Result")
            For Each row As DataGridViewRow In dgv.Rows
                If row.IsNewRow Then Continue For
                Try
                    Dim payee = Convert.ToString(row.Cells("PayeeName").Value)
                    Dim docType = Convert.ToString(row.Cells("DocType").Value)
                    Dim docNo = Convert.ToString(row.Cells("DocNo").Value)
                    Dim amount As Decimal = 0D
                    Decimal.TryParse(Convert.ToString(row.Cells("Amount").Value), amount)
                    Dim myRef = Convert.ToString(row.Cells("MyReference").Value)
                    Dim benRef = Convert.ToString(row.Cells("BeneficiaryReference").Value)
                    ' SupplierID is not available in this grid; pass 0 as placeholder (stored proc should handle or reject). Wrap in try.
                    Dim supplierId As Integer = 0
                    Dim paymentId As Integer = 0
                    Dim desc As String = $"{docType} {docNo}"
                    Dim jId = svc.PostAPSupplierPayment(paymentId, supplierId, Date.Today, amount, myRef, desc, createdBy, branchId)
                    postedCount += 1
                    remittance.Add(String.Join(",", {
                        SafeCsv(payee), SafeCsv(docType), SafeCsv(docNo), amount.ToString("0.00"), SafeCsv(myRef), SafeCsv(benRef), "Posted"
                    }))
                Catch exRow As Exception
                    errors.Add(exRow.Message)
                    Dim payee = Convert.ToString(row.Cells("PayeeName").Value)
                    Dim docType = Convert.ToString(row.Cells("DocType").Value)
                    Dim docNo = Convert.ToString(row.Cells("DocNo").Value)
                    Dim amount As Decimal = 0D
                    Decimal.TryParse(Convert.ToString(row.Cells("Amount").Value), amount)
                    Dim myRef = Convert.ToString(row.Cells("MyReference").Value)
                    Dim benRef = Convert.ToString(row.Cells("BeneficiaryReference").Value)
                    remittance.Add(String.Join(",", {
                        SafeCsv(payee), SafeCsv(docType), SafeCsv(docNo), amount.ToString("0.00"), SafeCsv(myRef), SafeCsv(benRef), $"Error: {SafeCsv(exRow.Message)}"
                    }))
                End Try
            Next

            ' Write remittance stub
            Try
                Dim folder = IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory), "ERP_Exports")
                IO.Directory.CreateDirectory(folder)
                Dim ts = DateTime.Now.ToString("yyyyMMdd_HHmmss")
                Dim remitPath = IO.Path.Combine(folder, $"Remittance_{ts}.csv")
                IO.File.WriteAllLines(remitPath, remittance)
            Catch
            End Try

            If errors.Count = 0 Then
                MessageBox.Show($"Posted {postedCount} payment lines.")
            Else
                MessageBox.Show($"Posted {postedCount} lines with {errors.Count} errors. See remittance CSV for details.")
            End If
        Catch ex As Exception
            MessageBox.Show($"Post error: {ex.Message}")
        End Try
    End Sub

    ' --- Bank validation and export placeholders ---
    Private Function ValidateForBank(bank As String) As Boolean
        ' Minimal sample rules per bank. Highlight invalid rows if needed.
        If dgv.DataSource Is Nothing Then Return False
        Dim ok As Boolean = True
        ' Clear previous highlights
        For Each row As DataGridViewRow In dgv.Rows
            row.DefaultCellStyle.BackColor = Color.White
        Next
        For Each row As DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            Dim payee = Convert.ToString(row.Cells("PayeeName").Value)
            Dim amount As Decimal = 0D
            Decimal.TryParse(Convert.ToString(row.Cells("Amount").Value), amount)
            Dim rowOk As Boolean = True
            Dim acc = Convert.ToString(If(row.Cells("AccountNumber"), Nothing)?.Value)
            Dim branch = Convert.ToString(If(row.Cells("BranchCode"), Nothing)?.Value)
            ' Example reference length rules (adjust per bank spec as needed)
            Dim myRef = Convert.ToString(row.Cells("MyReference").Value)
            Dim benRef = Convert.ToString(row.Cells("BeneficiaryReference").Value)
            Select Case bank
                Case "FNB"
                    ' Require account and branch code for FNB CSV import
                    If String.IsNullOrWhiteSpace(acc) OrElse String.IsNullOrWhiteSpace(branch) Then rowOk = False
                    If myRef IsNot Nothing AndAlso myRef.Length > 20 Then rowOk = False
                    If benRef IsNot Nothing AndAlso benRef.Length > 20 Then rowOk = False
                Case "Standard Bank"
                    If String.IsNullOrWhiteSpace(acc) OrElse String.IsNullOrWhiteSpace(branch) Then rowOk = False
                    If myRef IsNot Nothing AndAlso myRef.Length > 30 Then rowOk = False
                    If benRef IsNot Nothing AndAlso benRef.Length > 30 Then rowOk = False
                Case "ABSA"
                    If String.IsNullOrWhiteSpace(acc) OrElse String.IsNullOrWhiteSpace(branch) Then rowOk = False
                    If myRef IsNot Nothing AndAlso myRef.Length > 20 Then rowOk = False
                Case "Nedbank"
                    If String.IsNullOrWhiteSpace(acc) OrElse String.IsNullOrWhiteSpace(branch) Then rowOk = False
                    If myRef IsNot Nothing AndAlso myRef.Length > 30 Then rowOk = False
                    If benRef IsNot Nothing AndAlso benRef.Length > 30 Then rowOk = False
            End Select
            If Not rowOk Then
                row.DefaultCellStyle.BackColor = Color.MistyRose
                ok = False
            End If
        Next
        Return ok
    End Function

    Private Function ExportForBank(bank As String, fmt As String) As String
        Try
            Dim folder = IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory), "ERP_Exports")
            IO.Directory.CreateDirectory(folder)
            Dim ts = DateTime.Now.ToString("yyyyMMdd_HHmmss")
            If String.Equals(fmt, "PAIN.001", StringComparison.OrdinalIgnoreCase) Then
                Dim file = IO.Path.Combine(folder, $"PAY_{bank}_{ts}.xml")
                IO.File.WriteAllText(file, GeneratePain001Placeholder(bank))
                Return file
            Else
                Dim file = IO.Path.Combine(folder, $"PAY_{bank}_{ts}.csv")
                IO.File.WriteAllText(file, GenerateCsvPlaceholder(bank))
                Return file
            End If
        Catch
            Return Nothing
        End Try
    End Function

    Private Function GeneratePain001Placeholder(bank As String) As String
        Dim sb As New Text.StringBuilder()
        sb.Append("<?xml version=""1.0"" encoding=""UTF-8""?>")
        sb.Append("<Document xmlns=""urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"">")
        sb.Append("<CstmrCdtTrfInitn>")
        sb.Append("<GrpHdr>")
        sb.Append("<MsgId>ERP-PLACEHOLDER</MsgId>")
        sb.Append("<CreDtTm>2000-01-01T00:00:00</CreDtTm>")
        sb.Append("<NbOfTxs>0</NbOfTxs>")
        sb.Append("</GrpHdr>")
        sb.Append("</CstmrCdtTrfInitn>")
        sb.Append("</Document>")
        Return sb.ToString()
    End Function

    Private Function GenerateCsvPlaceholder(bank As String) As String
        Select Case bank
            Case "FNB"
                Return GenerateCsvFNB()
            Case "Standard Bank"
                Return GenerateCsvStandardBank()
            Case "ABSA"
                Return GenerateCsvABSA()
            Case "Nedbank"
                Return GenerateCsvNedbank()
            Case Else
                ' Generic fallback
                Dim sb As New Text.StringBuilder()
                sb.AppendLine("Payee,DocType,DocNo,DueDate,Amount,MyReference,BeneficiaryReference")
                For Each row As DataGridViewRow In dgv.Rows
                    If row.IsNewRow Then Continue For
                    Dim vals As New List(Of String) From {
                        SafeCsv(Convert.ToString(row.Cells("PayeeName").Value)),
                        SafeCsv(Convert.ToString(row.Cells("DocType").Value)),
                        SafeCsv(Convert.ToString(row.Cells("DocNo").Value)),
                        Convert.ToDateTime(row.Cells("DueDate").Value).ToString("yyyy-MM-dd"),
                        Convert.ToDecimal(row.Cells("Amount").Value).ToString("0.00"),
                        SafeCsv(Convert.ToString(row.Cells("MyReference").Value)),
                        SafeCsv(Convert.ToString(row.Cells("BeneficiaryReference").Value))
                    }
                    sb.AppendLine(String.Join(",", vals))
                Next
                Return sb.ToString()
        End Select
    End Function

    Private Function GenerateCsvNedbank() As String
        ' Nedbank Business CSV (simplified placeholder)
        Dim sb As New Text.StringBuilder()
        sb.AppendLine("Beneficiary,AccountNumber,BranchCode,Amount,MyReference,BeneficiaryReference")
        For Each row As DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            Dim name = SafeCsv(Convert.ToString(row.Cells("PayeeName").Value))
            Dim acc = SafeCsv(Convert.ToString(row.Cells("AccountNumber").Value))
            Dim branch = SafeCsv(Convert.ToString(row.Cells("BranchCode").Value))
            Dim amt = Convert.ToDecimal(row.Cells("Amount").Value).ToString("0.00")
            Dim myRef = SafeCsv(Convert.ToString(row.Cells("MyReference").Value))
            Dim benRef = SafeCsv(Convert.ToString(row.Cells("BeneficiaryReference").Value))
            sb.AppendLine(String.Join(",", {name, acc, branch, amt, myRef, benRef}))
        Next
        Return sb.ToString()
    End Function

    Private Function GenerateCsvFNB() As String
        ' FNB OBE Payment Import (simplified). Real template may differ; fill beneficiary bank details when available.
        Dim sb As New Text.StringBuilder()
        sb.AppendLine("BeneficiaryName,BeneficiaryAccount,BranchCode,Amount,MyReference,BeneficiaryReference")
        For Each row As DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            Dim name = SafeCsv(Convert.ToString(row.Cells("PayeeName").Value))
            Dim acc = SafeCsv(Convert.ToString(row.Cells("AccountNumber").Value))
            Dim branch = SafeCsv(Convert.ToString(row.Cells("BranchCode").Value))
            Dim amt = Convert.ToDecimal(row.Cells("Amount").Value).ToString("0.00")
            Dim myRef = SafeCsv(Convert.ToString(row.Cells("MyReference").Value))
            Dim benRef = SafeCsv(Convert.ToString(row.Cells("BeneficiaryReference").Value))
            sb.AppendLine(String.Join(",", {name, acc, branch, amt, myRef, benRef}))
        Next
        Return sb.ToString()
    End Function

    Private Function GenerateCsvStandardBank() As String
        ' Standard Bank BOL CSV (simplified placeholder)
        Dim sb As New Text.StringBuilder()
        sb.AppendLine("AccountName,AccountNumber,BranchCode,Amount,MyReference,BeneficiaryReference")
        For Each row As DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            Dim name = SafeCsv(Convert.ToString(row.Cells("PayeeName").Value))
            Dim acc = SafeCsv(Convert.ToString(row.Cells("AccountNumber").Value))
            Dim branch = SafeCsv(Convert.ToString(row.Cells("BranchCode").Value))
            Dim amt = Convert.ToDecimal(row.Cells("Amount").Value).ToString("0.00")
            Dim myRef = SafeCsv(Convert.ToString(row.Cells("MyReference").Value))
            Dim benRef = SafeCsv(Convert.ToString(row.Cells("BeneficiaryReference").Value))
            sb.AppendLine(String.Join(",", {name, acc, branch, amt, myRef, benRef}))
        Next
        Return sb.ToString()
    End Function

    Private Function GenerateCsvABSA() As String
        ' ABSA BIO CSV (simplified placeholder)
        Dim sb As New Text.StringBuilder()
        sb.AppendLine("AccName,AccNo,Branch,Amount,YourRef,TheirRef")
        For Each row As DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            Dim name = SafeCsv(Convert.ToString(row.Cells("PayeeName").Value))
            Dim acc = SafeCsv(Convert.ToString(row.Cells("AccountNumber").Value))
            Dim branch = SafeCsv(Convert.ToString(row.Cells("BranchCode").Value))
            Dim amt = Convert.ToDecimal(row.Cells("Amount").Value).ToString("0.00")
            Dim yourRef = SafeCsv(Convert.ToString(row.Cells("MyReference").Value))
            Dim theirRef = SafeCsv(Convert.ToString(row.Cells("BeneficiaryReference").Value))
            sb.AppendLine(String.Join(",", {name, acc, branch, amt, yourRef, theirRef}))
        Next
        Return sb.ToString()
    End Function

    Private Function SafeCsv(v As String) As String
        If v Is Nothing Then Return ""
        Dim s As String = v.Replace(vbCr, " ").Replace(vbLf, " ")
        Dim dq As Char = ChrW(34)
        If s.IndexOf(","c) >= 0 OrElse s.IndexOf(dq) >= 0 Then
            s = dq & s.Replace(dq, dq & dq) & dq
        End If
        Return s
    End Function

    Private Sub btnSubmitFNB_Click(sender As Object, e As EventArgs) Handles btnSubmitFNB.Click
        Try
            If dgv.DataSource Is Nothing OrElse dgv.Rows.Count = 0 Then
                MessageBox.Show("Please load payment items first.", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Validate FNB requirements
            Dim bank = If(cboBank.SelectedItem, "").ToString()
            If bank <> "FNB" Then
                Dim result = MessageBox.Show(
                    "This will submit payments via FNB Payment Execution API." & Environment.NewLine & Environment.NewLine &
                    "*** SANDBOX TESTING MODE ***" & Environment.NewLine &
                    "Using test beneficiary accounts." & Environment.NewLine & Environment.NewLine &
                    "Continue?",
                    "FNB API Submission",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question
                )
                If result <> DialogResult.Yes Then Return
            End If

            If Not ValidateForBank("FNB") Then
                MessageBox.Show("Validation failed. Please fix highlighted rows before submitting.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Build payment lines
            Dim paymentLines As New List(Of PaymentLineInfo)()
            For Each row As DataGridViewRow In dgv.Rows
                If row.IsNewRow Then Continue For

                Dim line As New PaymentLineInfo() With {
                    .SupplierID = If(row.Cells("SupplierID").Value IsNot Nothing, CInt(row.Cells("SupplierID").Value), Nothing),
                    .PaymentType = "Supplier",
                    .CreditorName = Convert.ToString(row.Cells("PayeeName").Value),
                    .CreditorAccountNumber = Convert.ToString(row.Cells("AccountNumber").Value),
                    .CreditorAccountType = "CACC",
                    .CreditorBranchCode = Convert.ToString(row.Cells("BranchCode").Value),
                    .CreditorBIC = "FIRNZAJJ",
                    .Amount = CDec(row.Cells("Amount").Value),
                    .Reference = Convert.ToString(row.Cells("MyReference").Value),
                    .ProofOfPaymentEmail = If(row.Cells("Email") IsNot Nothing, Convert.ToString(row.Cells("Email").Value), Nothing)
                }

                paymentLines.Add(line)
            Next

            If paymentLines.Count = 0 Then
                MessageBox.Show("No valid payment lines to submit.", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Show confirmation
            Dim totalAmount = paymentLines.Sum(Function(p) p.Amount)
            Dim confirmMsg = $"Submit {paymentLines.Count} payment(s) totaling R{totalAmount:N2} to FNB API?" & Environment.NewLine & Environment.NewLine &
                           $"*** SANDBOX MODE - Test accounts will be used ***" & Environment.NewLine & Environment.NewLine &
                           $"Execution Date: {Date.Today.AddDays(1):yyyy-MM-dd}"

            If MessageBox.Show(confirmMsg, "Confirm Submission", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> DialogResult.Yes Then
                Return
            End If

            ' Submit to FNB API
            Cursor = Cursors.WaitCursor
            btnSubmitFNB.Enabled = False
            
            ' Clear status log
            txtTestResults.Clear()
            LogMessage("Preparing FNB batch payment submission...")

            Dim paymentService As New FNBPaymentExecutionService(_connectionString, "Sandbox")
            
            ' Wire up status event handler
            AddHandler paymentService.StatusUpdate, AddressOf LogMessage
            
            Dim executionDate = Date.Today.AddDays(1) ' Next business day
            Dim branchId = AppSession.CurrentBranchID
            Dim createdBy = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.UserID, 0)

            Dim submitResult = paymentService.CreateAndSubmitPaymentBatch(paymentLines, executionDate, branchId, createdBy)
            
            ' Remove event handler
            RemoveHandler paymentService.StatusUpdate, AddressOf LogMessage

            Cursor = Cursors.Default
            btnSubmitFNB.Enabled = True

            If submitResult.Item1 Then
                MessageBox.Show(
                    $"Payment batch submitted successfully!" & Environment.NewLine & Environment.NewLine &
                    submitResult.Item2 & Environment.NewLine & Environment.NewLine &
                    $"Batch ID: {submitResult.Item3}" & Environment.NewLine & Environment.NewLine &
                    "Click 'View Transactions' to monitor payment status.",
                    "Success",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information
                )

                ' Clear grid after successful submission
                dgv.DataSource = Nothing
            Else
                MessageBox.Show(
                    $"Failed to submit payment batch:" & Environment.NewLine & Environment.NewLine &
                    submitResult.Item2,
                    "Submission Failed",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                )
            End If

        Catch ex As Exception
            Cursor = Cursors.Default
            btnSubmitFNB.Enabled = True
            MessageBox.Show($"Error submitting to FNB API: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnViewTransactions_Click(sender As Object, e As EventArgs) Handles btnViewTransactions.Click
        Try
            Dim viewForm As New FNBTransactionViewerForm()
            viewForm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error opening transaction viewer: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
