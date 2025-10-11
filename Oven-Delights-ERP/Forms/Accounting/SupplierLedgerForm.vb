Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Drawing
Imports System.Windows.Forms

Public Class SupplierLedgerForm
    Inherits Form

    Private ReadOnly _conn As String
    Private ReadOnly _isSuper As Boolean
    Private ReadOnly _branchId As Integer

    Private ReadOnly lblTitle As New Label()
    Private ReadOnly lblBranch As New Label()
    Private ReadOnly cboBranch As New ComboBox()
    Private ReadOnly lblSupplier As New Label()
    Private ReadOnly cboSupplier As New ComboBox()
    Private ReadOnly lblFrom As New Label()
    Private ReadOnly dtFrom As New DateTimePicker()
    Private ReadOnly lblTo As New Label()
    Private ReadOnly dtTo As New DateTimePicker()
    Private ReadOnly btnLoad As New Button()
    Private ReadOnly btnExport As New Button()

    Private ReadOnly grid As New DataGridView()
    Private ReadOnly lblTotals As New Label()

    Public Sub New()
        Me.Text = "Accounting - Supplier Ledger"
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.WindowState = FormWindowState.Maximized
        _conn = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _isSuper = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _branchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)

        ' Header
        lblTitle.Text = "Supplier Ledger"
        lblTitle.Font = New Font("Segoe UI", 14, FontStyle.Bold)
        lblTitle.AutoSize = True
        lblTitle.Top = 10
        lblTitle.Left = 12

        lblBranch.Text = "Branch:"
        lblBranch.AutoSize = True
        lblBranch.Top = 14
        lblBranch.Left = 260

        cboBranch.DropDownStyle = ComboBoxStyle.DropDownList
        cboBranch.Top = 10
        cboBranch.Left = 320
        cboBranch.Width = 200

        lblSupplier.Text = "Supplier:"
        lblSupplier.AutoSize = True
        lblSupplier.Top = 14
        lblSupplier.Left = 540

        cboSupplier.DropDownStyle = ComboBoxStyle.DropDownList
        cboSupplier.Top = 10
        cboSupplier.Left = 610
        cboSupplier.Width = 280

        lblFrom.Text = "From:"
        lblFrom.AutoSize = True
        lblFrom.Top = 14
        lblFrom.Left = 910

        dtFrom.Format = DateTimePickerFormat.Custom
        dtFrom.CustomFormat = "dd MMM yyyy"
        dtFrom.Top = 10
        dtFrom.Left = 950
        dtFrom.Width = 120
        dtFrom.Value = Date.Today.AddMonths(-1)

        lblTo.Text = "To:"
        lblTo.AutoSize = True
        lblTo.Top = 14
        lblTo.Left = 1080

        dtTo.Format = DateTimePickerFormat.Custom
        dtTo.CustomFormat = "dd MMM yyyy"
        dtTo.Top = 10
        dtTo.Left = 1108
        dtTo.Width = 120
        dtTo.Value = Date.Today

        btnLoad.Text = "Load"
        btnLoad.Top = 8
        btnLoad.Left = 1240
        AddHandler btnLoad.Click, AddressOf OnLoadClick

        btnExport.Text = "Export CSV"
        btnExport.Top = 8
        btnExport.Left = 1308
        AddHandler btnExport.Click, AddressOf OnExportClick

        Dim header As New Panel() With {.Dock = DockStyle.Top, .Height = 46}
        header.Controls.AddRange(New Control() {lblTitle, lblBranch, cboBranch, lblSupplier, cboSupplier, lblFrom, dtFrom, lblTo, dtTo, btnLoad, btnExport})

        grid.Dock = DockStyle.Fill
        grid.ReadOnly = True
        grid.AllowUserToAddRows = False
        grid.AllowUserToDeleteRows = False
        grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

        lblTotals.Dock = DockStyle.Bottom
        lblTotals.Height = 28
        lblTotals.TextAlign = ContentAlignment.MiddleRight

        Me.Controls.AddRange(New Control() {grid, lblTotals, header})

        LoadBranches()
        LoadSuppliers()
    End Sub

    Private Sub LoadBranches()
        Try
            Using cn As New SqlConnection(_conn)
                cn.Open()
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter("SELECT BranchID, BranchName FROM dbo.Branches ORDER BY BranchName", cn)
                    da.Fill(dt)
                End Using
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                cboBranch.DataSource = dt
                If _isSuper Then
                    ' Super admin can choose, default to current if available
                    If _branchId > 0 Then cboBranch.SelectedValue = _branchId
                Else
                    ' Non-super: lock to their branch
                    lblBranch.Visible = False
                    cboBranch.Visible = False
                End If
            End Using
        Catch
            ' Ignore and leave hidden
            lblBranch.Visible = False
            cboBranch.Visible = False
        End Try
    End Sub

    Private Sub LoadSuppliers()
        Try
            Using cn As New SqlConnection(_conn)
                cn.Open()
                Dim dt As New DataTable()
                ' Load from Suppliers table
                Dim sql = "SELECT SupplierID, CompanyName AS SupplierName FROM dbo.Suppliers WHERE IsActive = 1 ORDER BY CompanyName"
                Using da As New SqlDataAdapter(sql, cn)
                    da.Fill(dt)
                End Using
                cboSupplier.DisplayMember = "SupplierName"
                cboSupplier.ValueMember = "SupplierID"
                cboSupplier.DataSource = dt
                cboSupplier.SelectedIndex = -1
            End Using
        Catch
        End Try
    End Sub

    Private Function GetBranchParam() As Object
        If _isSuper Then
            Dim v = If(cboBranch IsNot Nothing, cboBranch.SelectedValue, Nothing)
            Return If(v Is Nothing OrElse v Is DBNull.Value, DBNull.Value, v)
        End If
        If _branchId <= 0 Then Return DBNull.Value
        Return _branchId
    End Function

    Private Sub OnLoadClick(sender As Object, e As EventArgs)
        LoadLedger()
    End Sub

    Private Sub LoadLedger()
        Try
            If cboSupplier.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a supplier.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim supplierId As Integer = Convert.ToInt32(cboSupplier.SelectedValue)
            
            Using cn As New SqlConnection(_conn)
                cn.Open()
                
                ' Get supplier transactions from SupplierInvoices and SupplierPayments
                Dim sql As String = ""
                sql &= "SELECT PostDate, AccountCode, AccountName, Ref, Description, Debit, Credit "
                sql &= "FROM ( "
                sql &= "    SELECT "
                sql &= "        si.InvoiceDate AS PostDate, "
                sql &= "        '2100' AS AccountCode, "
                sql &= "        'Accounts Payable' AS AccountName, "
                sql &= "        si.InvoiceNumber AS Ref, "
                sql &= "        'Invoice: ' + si.InvoiceNumber AS Description, "
                sql &= "        CAST(0 AS DECIMAL(18,2)) AS Debit, "
                sql &= "        si.TotalAmount AS Credit "
                sql &= "    FROM SupplierInvoices si "
                sql &= "    WHERE si.SupplierID = @suppId "
                sql &= "    AND (@branchId IS NULL OR si.BranchID = @branchId) "
                sql &= "    AND si.InvoiceDate BETWEEN @fromDate AND @toDate "
                sql &= "    UNION ALL "
                sql &= "    SELECT "
                sql &= "        sp.PaymentDate AS PostDate, "
                sql &= "        '1100' AS AccountCode, "
                sql &= "        'Bank' AS AccountName, "
                sql &= "        sp.PaymentNumber AS Ref, "
                sql &= "        'Payment: ' + sp.PaymentMethod + ISNULL(' - ' + sp.Reference, '') AS Description, "
                sql &= "        sp.PaymentAmount AS Debit, "
                sql &= "        CAST(0 AS DECIMAL(18,2)) AS Credit "
                sql &= "    FROM SupplierPayments sp "
                sql &= "    WHERE sp.SupplierID = @suppId "
                sql &= "    AND (@branchId IS NULL OR sp.BranchID = @branchId) "
                sql &= "    AND sp.PaymentDate BETWEEN @fromDate AND @toDate "
                sql &= ") AS Transactions "
                sql &= "ORDER BY PostDate, Ref"

                Using da As New SqlDataAdapter(sql, cn)
                    Dim dt As New DataTable()
                    da.SelectCommand.Parameters.Add("@suppId", SqlDbType.Int).Value = supplierId
                    Dim branchParam = GetBranchParam()
                    If branchParam Is DBNull.Value Then
                        da.SelectCommand.Parameters.Add("@branchId", SqlDbType.Int).Value = DBNull.Value
                    Else
                        da.SelectCommand.Parameters.Add("@branchId", SqlDbType.Int).Value = branchParam
                    End If
                    da.SelectCommand.Parameters.Add("@fromDate", SqlDbType.DateTime).Value = dtFrom.Value.Date
                    da.SelectCommand.Parameters.Add("@toDate", SqlDbType.DateTime).Value = dtTo.Value.Date.AddDays(1).AddSeconds(-1)
                    da.Fill(dt)
                    grid.DataSource = dt
                    ComputeTotals(dt)
                    
                    If dt.Rows.Count = 0 Then
                        MessageBox.Show("No transactions found for this supplier in the selected date range.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show(Me, ex.Message, "Supplier Ledger", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ComputeTotals(dt As DataTable)
        Dim deb As Decimal = 0D, cre As Decimal = 0D
        For Each r As DataRow In dt.Rows
            If Not r.IsNull("Debit") Then deb += Convert.ToDecimal(r("Debit"))
            If Not r.IsNull("Credit") Then cre += Convert.ToDecimal(r("Credit"))
        Next
        lblTotals.Text = $"Total Debit: {deb:N2}    Total Credit: {cre:N2}    Balance: {(deb - cre):N2}"
    End Sub

    Private Sub OnExportClick(sender As Object, e As EventArgs)
        Try
            Using sfd As New SaveFileDialog()
                sfd.Filter = "CSV files (*.csv)|*.csv"
                sfd.FileName = $"SupplierLedger_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
                If sfd.ShowDialog(Me) = DialogResult.OK Then
                    Using sw As New IO.StreamWriter(sfd.FileName, False, System.Text.Encoding.UTF8)
                        ' headers
                        Dim cols = grid.Columns
                        Dim headers As New List(Of String)()
                        For Each c As DataGridViewColumn In cols
                            If c.Visible Then headers.Add(SafeCsv(c.HeaderText))
                        Next
                        sw.WriteLine(String.Join(",", headers))
                        ' rows
                        For Each row As DataGridViewRow In grid.Rows
                            If row.IsNewRow Then Continue For
                            Dim vals As New List(Of String)()
                            For Each c As DataGridViewColumn In cols
                                If Not c.Visible Then Continue For
                                Dim v = row.Cells(c.Index).Value
                                vals.Add(SafeCsv(If(v, "").ToString()))
                            Next
                            sw.WriteLine(String.Join(",", vals))
                        Next
                    End Using
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show(Me, ex.Message, "Export", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function SafeCsv(s As String) As String
        If s Is Nothing Then Return ""
        If s.Contains(",") OrElse s.Contains("""") OrElse s.Contains(ChrW(10)) OrElse s.Contains(ChrW(13)) Then
            Return """" & s.Replace("""", """""") & """"
        End If
        Return s
    End Function
End Class
