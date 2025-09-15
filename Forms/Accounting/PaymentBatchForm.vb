Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class PaymentBatchForm
    Private Sub PaymentBatchForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Super Admin can choose bank/format for any branch; others are locked by branch rule elsewhere when posting
            cboBank.SelectedIndex = 0
            cboFormat.SelectedIndex = 1 ' CSV by default
        Catch ex As Exception
            MessageBox.Show($"Error initializing Payment Batch: {ex.Message}")
        End Try
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        Try
            ' TODO: Replace with real loader combining AP invoices/credits + Expense Bills + Misc
            Dim dt As New DataTable()
            dt.Columns.Add("PayeeName")
            dt.Columns.Add("DocType")
            dt.Columns.Add("DocNo")
            dt.Columns.Add("DueDate", GetType(Date))
            dt.Columns.Add("Amount", GetType(Decimal))
            dt.Columns.Add("MyReference")
            dt.Columns.Add("BeneficiaryReference")
            ' Bank details for exports (placeholders until Supplier Bank Master is wired)
            dt.Columns.Add("AccountNumber")
            dt.Columns.Add("BranchCode")
            dt.Rows.Add("City of Metropolis", "Expense", "RATES-SEP", Date.Today, 1234.56D, "BATCH-0001", "RATES", "", "")
            dt.Rows.Add("Eskom", "Expense", "ELEC-SEP", Date.Today, 3456.78D, "BATCH-0001", "ELECTRICITY", "", "")
            dt.Rows.Add("ABC Supplies", "AP Invoice", "INV-10023", Date.Today, 987.65D, "BATCH-0001", "INV-10023", "", "")
            dgv.DataSource = dt
        Catch ex As Exception
            MessageBox.Show($"Error loading payables: {ex.Message}")
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
End Class
