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
                ' Try common supplier table names
                Dim sqls As String() = {
                    "SELECT SupplierID, SupplierName FROM dbo.Suppliers ORDER BY SupplierName",
                    "SELECT VendorID AS SupplierID, VendorName AS SupplierName FROM dbo.Vendors ORDER BY VendorName"
                }
                For Each q In sqls
                    dt.Clear()
                    Using da As New SqlDataAdapter(q, cn)
                        Try
                            da.Fill(dt)
                        Catch
                            dt.Clear()
                        End Try
                    End Using
                    If dt.Rows.Count > 0 Then Exit For
                Next
                cboSupplier.DisplayMember = "SupplierName"
                cboSupplier.ValueMember = "SupplierID"
                cboSupplier.DataSource = dt
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
            Using cn As New SqlConnection(_conn)
                Dim sql As String = ""
                sql &= "DECLARE @B INT = @pBranch;" & vbCrLf
                sql &= "DECLARE @From DATETIME2 = @pFrom;" & vbCrLf
                sql &= "DECLARE @To DATETIME2 = @pTo;" & vbCrLf
                sql &= "DECLARE @Supp INT = @pSupplier;" & vbCrLf
                ' Try a canonical GL view first
                sql &= "IF OBJECT_ID('dbo.v_GL_Entries','V') IS NOT NULL " & _
                       "SELECT PostDate, AccountCode, AccountName, Ref, Description, Debit, Credit " & _
                       "FROM dbo.v_GL_Entries WHERE (@B IS NULL OR BranchID=@B) AND (@Supp IS NULL OR SupplierID=@Supp) AND PostDate BETWEEN @From AND @To ORDER BY PostDate; " & vbCrLf
                sql &= "ELSE IF OBJECT_ID('dbo.GLTransactions','U') IS NOT NULL " & _
                       "SELECT TranDate AS PostDate, AccountCode, AccountName, Reference AS Ref, Narrative AS Description, Debit, Credit " & _
                       "FROM dbo.GLTransactions WHERE (@B IS NULL OR BranchID=@B) AND (@Supp IS NULL OR SupplierID=@Supp) AND TranDate BETWEEN @From AND @To ORDER BY TranDate; " & vbCrLf
                sql &= "ELSE SELECT CAST(NULL AS DATETIME2) AS PostDate, CAST('' AS NVARCHAR(50)) AS AccountCode, CAST('' AS NVARCHAR(200)) AS AccountName, CAST('' AS NVARCHAR(100)) AS Ref, CAST('No GL source found' AS NVARCHAR(200)) AS Description, CAST(0 AS DECIMAL(18,2)) AS Debit, CAST(0 AS DECIMAL(18,2)) AS Credit WHERE 1=0;"

                Using da As New SqlDataAdapter(sql, cn)
                    Dim dt As New DataTable()
                    da.SelectCommand.Parameters.AddWithValue("@pBranch", GetBranchParam())
                    Dim selSupp As Object = If(cboSupplier.SelectedValue, DBNull.Value)
                    If TypeOf selSupp Is DBNull Then
                        da.SelectCommand.Parameters.AddWithValue("@pSupplier", DBNull.Value)
                    Else
                        da.SelectCommand.Parameters.AddWithValue("@pSupplier", Convert.ToInt32(selSupp))
                    End If
                    da.SelectCommand.Parameters.AddWithValue("@pFrom", dtFrom.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@pTo", dtTo.Value.Date.AddDays(1).AddSeconds(-1))
                    da.Fill(dt)
                    grid.DataSource = dt
                    ComputeTotals(dt)
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
