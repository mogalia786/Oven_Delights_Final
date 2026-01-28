Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class FinancialStatementsForm
        Inherits Form

        Private WithEvents tabControl As TabControl
        Private WithEvents dgvProfitLoss As DataGridView
        Private WithEvents dgvBalanceSheet As DataGridView
        Private WithEvents btnRefreshPL As Button
        Private WithEvents btnRefreshBS As Button
        Private WithEvents btnExport As Button
        Private WithEvents dtpPLFromDate As DateTimePicker
        Private WithEvents dtpPLToDate As DateTimePicker
        Private WithEvents dtpBSAsOfDate As DateTimePicker
        Private WithEvents cboBranchPL As ComboBox
        Private WithEvents cboBranchBS As ComboBox
        Private WithEvents lblPLSummary As Label
        Private WithEvents lblBSSummary As Label
        Private _connString As String
        Private _currentBranchID As Integer
        Private _currentUserID As Integer

        Public Sub New()
            Try
                InitializeComponent()
                _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
                
                ' Handle AppSession safely
                Try
                    _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
                    _currentUserID = If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1)
                Catch
                    _currentBranchID = 0
                    _currentUserID = 1
                End Try
                
                If String.IsNullOrEmpty(_connString) Then
                    MessageBox.Show("Connection string not found. Please check your configuration.", "Configuration Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
                
                LoadBranches()
                LoadProfitAndLoss()
                LoadBalanceSheet()
            Catch ex As Exception
                MessageBox.Show($"Error initializing Financial Statements form: {ex.Message}", "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Financial Statements"
            Me.Size = New Size(1400, 900)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(52, 73, 94),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "Financial Statements",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "Profit & Loss and Balance Sheet Reports",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            tabControl = New TabControl() With {
                .Dock = DockStyle.Fill,
                .Padding = New Point(10, 5)
            }

            Dim tabPL As New TabPage("Profit & Loss") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            Dim pnlPLFilter As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblPLFromDate As New Label() With {
                .Text = "From Date:",
                .Location = New Point(20, 18),
                .AutoSize = True
            }
            pnlPLFilter.Controls.Add(lblPLFromDate)

            dtpPLFromDate = New DateTimePicker() With {
                .Location = New Point(100, 15),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Value = New DateTime(DateTime.Today.Year, DateTime.Today.Month, 1)
            }
            pnlPLFilter.Controls.Add(dtpPLFromDate)

            Dim lblPLToDate As New Label() With {
                .Text = "To Date:",
                .Location = New Point(270, 18),
                .AutoSize = True
            }
            pnlPLFilter.Controls.Add(lblPLToDate)

            dtpPLToDate = New DateTimePicker() With {
                .Location = New Point(340, 15),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Today
            }
            pnlPLFilter.Controls.Add(dtpPLToDate)

            Dim lblBranchPL As New Label() With {
                .Text = "Branch:",
                .Location = New Point(510, 18),
                .AutoSize = True
            }
            pnlPLFilter.Controls.Add(lblBranchPL)

            cboBranchPL = New ComboBox() With {
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Location = New Point(580, 15),
                .Width = 200
            }
            pnlPLFilter.Controls.Add(cboBranchPL)

            btnRefreshPL = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(800, 13),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlPLFilter.Controls.Add(btnRefreshPL)

            lblPLSummary = New Label() With {
                .Text = "Net Profit: R0.00",
                .Location = New Point(20, 50),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlPLFilter.Controls.Add(lblPLSummary)

            dgvProfitLoss = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }

            tabPL.Controls.Add(dgvProfitLoss)
            tabPL.Controls.Add(pnlPLFilter)

            Dim tabBS As New TabPage("Balance Sheet") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            Dim pnlBSFilter As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblBSAsOfDate As New Label() With {
                .Text = "As of Date:",
                .Location = New Point(20, 18),
                .AutoSize = True
            }
            pnlBSFilter.Controls.Add(lblBSAsOfDate)

            dtpBSAsOfDate = New DateTimePicker() With {
                .Location = New Point(100, 15),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Today
            }
            pnlBSFilter.Controls.Add(dtpBSAsOfDate)

            Dim lblBranchBS As New Label() With {
                .Text = "Branch:",
                .Location = New Point(270, 18),
                .AutoSize = True
            }
            pnlBSFilter.Controls.Add(lblBranchBS)

            cboBranchBS = New ComboBox() With {
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Location = New Point(340, 15),
                .Width = 200
            }
            pnlBSFilter.Controls.Add(cboBranchBS)

            btnRefreshBS = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(560, 13),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlBSFilter.Controls.Add(btnRefreshBS)

            lblBSSummary = New Label() With {
                .Text = "Total Assets: R0.00 | Total Liabilities + Equity: R0.00",
                .Location = New Point(20, 50),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlBSFilter.Controls.Add(lblBSSummary)

            dgvBalanceSheet = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }

            tabBS.Controls.Add(dgvBalanceSheet)
            tabBS.Controls.Add(pnlBSFilter)

            tabControl.TabPages.Add(tabPL)
            tabControl.TabPages.Add(tabBS)

            Me.Controls.Add(tabControl)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadBranches()
            Try
                cboBranchPL.Items.Clear()
                cboBranchBS.Items.Clear()
                
                cboBranchPL.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                cboBranchBS.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim branch = New With {
                                    .BranchID = reader.GetInt32(0),
                                    .BranchName = reader.GetString(1)
                                }
                                cboBranchPL.Items.Add(branch)
                                cboBranchBS.Items.Add(branch)
                            End While
                        End Using
                    End Using
                End Using
                
                cboBranchPL.DisplayMember = "BranchName"
                cboBranchPL.ValueMember = "BranchID"
                cboBranchBS.DisplayMember = "BranchName"
                cboBranchBS.ValueMember = "BranchID"
                
                If cboBranchPL.Items.Count > 0 Then cboBranchPL.SelectedIndex = 0
                If cboBranchBS.Items.Count > 0 Then cboBranchBS.SelectedIndex = 0
            Catch ex As Exception
                MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadProfitAndLoss()
            Try
                ' Validate controls are initialized
                If dtpPLFromDate Is Nothing OrElse dtpPLToDate Is Nothing OrElse dgvProfitLoss Is Nothing Then
                    System.Diagnostics.Debug.WriteLine("P&L controls not initialized yet")
                    Return
                End If
                
                If String.IsNullOrEmpty(_connString) Then
                    System.Diagnostics.Debug.WriteLine("Connection string is null")
                    Return
                End If
                
                Dim branchID As Integer? = Nothing
                If cboBranchPL IsNot Nothing AndAlso cboBranchPL.SelectedItem IsNot Nothing Then
                    Try
                        Dim selectedBranch = DirectCast(cboBranchPL.SelectedItem, Object)
                        Dim bid = CInt(selectedBranch.BranchID)
                        If bid > 0 Then branchID = bid
                    Catch
                        ' Ignore branch selection errors
                    End Try
                End If

                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_GL_ProfitAndLoss", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@FromDate", dtpPLFromDate.Value.Date)
                        cmd.Parameters.AddWithValue("@ToDate", dtpPLToDate.Value.Date)
                        If branchID.HasValue Then
                            cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                        Else
                            cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                        End If

                        Using adapter As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            adapter.Fill(dt)
                            
                            If dt.Rows.Count > 0 Then
                                dgvProfitLoss.DataSource = dt
                                FormatProfitLossGrid()
                                
                                If lblPLSummary IsNot Nothing Then
                                    ' Find NET PROFIT or NET LOSS
                                    Dim netProfitRow = dt.AsEnumerable().FirstOrDefault(Function(r) r.Field(Of String)("AccountName").Contains("NET PROFIT"))
                                    Dim netLossRow = dt.AsEnumerable().FirstOrDefault(Function(r) r.Field(Of String)("AccountName").Contains("NET LOSS"))
                                    
                                    If netProfitRow IsNot Nothing Then
                                        Dim netProfit = netProfitRow.Field(Of Decimal)("Amount")
                                        lblPLSummary.Text = $"Net Profit: R{netProfit:N2}"
                                        lblPLSummary.ForeColor = Color.FromArgb(46, 204, 113)
                                    ElseIf netLossRow IsNot Nothing Then
                                        Dim netLoss = netLossRow.Field(Of Decimal)("Amount")
                                        lblPLSummary.Text = $"Net Loss: R{netLoss:N2}"
                                        lblPLSummary.ForeColor = Color.FromArgb(231, 76, 60)
                                    Else
                                        lblPLSummary.Text = "Net Profit: R0.00"
                                        lblPLSummary.ForeColor = Color.FromArgb(52, 73, 94)
                                    End If
                                End If
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Dim errorMsg As String = $"Error loading Profit & Loss: {ex.Message}{vbCrLf}{vbCrLf}Stack: {ex.StackTrace}"
                System.Diagnostics.Debug.WriteLine(errorMsg)
                MessageBox.Show($"Error loading Profit & Loss: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadBalanceSheet()
            Try
                ' Validate controls are initialized
                If dtpBSAsOfDate Is Nothing OrElse dgvBalanceSheet Is Nothing Then
                    System.Diagnostics.Debug.WriteLine("Balance Sheet controls not initialized yet")
                    Return
                End If
                
                If String.IsNullOrEmpty(_connString) Then
                    System.Diagnostics.Debug.WriteLine("Connection string is null")
                    Return
                End If
                
                Dim branchID As Integer? = Nothing
                If cboBranchBS IsNot Nothing AndAlso cboBranchBS.SelectedItem IsNot Nothing Then
                    Try
                        Dim selectedBranch = DirectCast(cboBranchBS.SelectedItem, Object)
                        Dim bid = CInt(selectedBranch.BranchID)
                        If bid > 0 Then branchID = bid
                    Catch
                        ' Ignore branch selection errors
                    End Try
                End If

                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_GL_BalanceSheet", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@AsOfDate", dtpBSAsOfDate.Value.Date)
                        If branchID.HasValue Then
                            cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                        Else
                            cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                        End If

                        Using adapter As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            adapter.Fill(dt)
                            
                            ' Debug: Show actual columns returned
                            Dim columnNames As String = String.Join(", ", dt.Columns.Cast(Of DataColumn)().Select(Function(c) c.ColumnName))
                            System.Diagnostics.Debug.WriteLine($"Balance Sheet Columns: {columnNames}")
                            
                            If dt.Rows.Count > 0 Then
                                dgvBalanceSheet.DataSource = dt
                                FormatBalanceSheetGrid()
                                
                                Dim assetsRow = dt.AsEnumerable().FirstOrDefault(Function(r) r.Field(Of String)("AccountName") = "TOTAL ASSETS")
                                Dim liabEquityRow = dt.AsEnumerable().FirstOrDefault(Function(r) r.Field(Of String)("AccountName") = "TOTAL LIABILITIES + EQUITY")
                                
                                If assetsRow IsNot Nothing AndAlso liabEquityRow IsNot Nothing Then
                                    Dim assets = assetsRow.Field(Of Decimal)("Amount")
                                    Dim liabEquity = liabEquityRow.Field(Of Decimal)("Amount")
                                    lblBSSummary.Text = $"Total Assets: R{assets:N2} | Total Liabilities + Equity: R{liabEquity:N2}"
                                    lblBSSummary.ForeColor = If(assets = liabEquity, Color.FromArgb(46, 204, 113), Color.FromArgb(231, 76, 60))
                                Else
                                    lblBSSummary.Text = "Balance Sheet loaded"
                                    lblBSSummary.ForeColor = Color.FromArgb(52, 73, 94)
                                End If
                            Else
                                lblBSSummary.Text = "No data available"
                                lblBSSummary.ForeColor = Color.FromArgb(231, 76, 60)
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Dim errorDetails As String = $"Error loading Balance Sheet:{vbCrLf}{ex.Message}{vbCrLf}{vbCrLf}Stack Trace:{vbCrLf}{ex.StackTrace}"
                System.Diagnostics.Debug.WriteLine(errorDetails)
                MessageBox.Show($"Error loading balance sheet: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatProfitLossGrid()
            If dgvProfitLoss.Columns.Count > 0 Then
                If dgvProfitLoss.Columns.Contains("SortOrder") Then
                    dgvProfitLoss.Columns("SortOrder").Visible = False
                End If
                
                dgvProfitLoss.Columns("Side").HeaderText = "Side"
                dgvProfitLoss.Columns("Side").Width = 80
                dgvProfitLoss.Columns("AccountName").HeaderText = "Description"
                dgvProfitLoss.Columns("AccountName").Width = 300
                dgvProfitLoss.Columns("Amount").HeaderText = "Amount"
                dgvProfitLoss.Columns("Amount").DefaultCellStyle.Format = "N2"
                dgvProfitLoss.Columns("Amount").Width = 150
                
                For Each row As DataGridViewRow In dgvProfitLoss.Rows
                    If Not row.IsNewRow Then
                        Dim side = row.Cells("Side").Value?.ToString()
                        Dim accountName = row.Cells("AccountName").Value?.ToString()
                        
                        ' Color code by side
                        If side = "DEBIT" Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 245, 245)
                        ElseIf side = "CREDIT" Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(245, 255, 245)
                        End If
                        
                        ' Bold totals
                        If accountName?.Contains("NET PROFIT") OrElse accountName?.Contains("NET LOSS") Then
                            row.DefaultCellStyle.Font = New Font(dgvProfitLoss.Font, FontStyle.Bold)
                        End If
                    End If
                Next
            End If
        End Sub

        Private Sub FormatBalanceSheetGrid()
            If dgvBalanceSheet.Columns.Count > 0 Then
                If dgvBalanceSheet.Columns.Contains("SortOrder") Then
                    dgvBalanceSheet.Columns("SortOrder").Visible = False
                End If
                
                dgvBalanceSheet.Columns("Side").HeaderText = "Side"
                dgvBalanceSheet.Columns("Side").Width = 80
                dgvBalanceSheet.Columns("AccountName").HeaderText = "Description"
                dgvBalanceSheet.Columns("AccountName").Width = 300
                dgvBalanceSheet.Columns("Amount").HeaderText = "Amount"
                dgvBalanceSheet.Columns("Amount").DefaultCellStyle.Format = "N2"
                dgvBalanceSheet.Columns("Amount").Width = 150
                
                For Each row As DataGridViewRow In dgvBalanceSheet.Rows
                    If Not row.IsNewRow Then
                        Dim side = row.Cells("Side").Value?.ToString()
                        Dim accountName = row.Cells("AccountName").Value?.ToString()
                        
                        ' Color code by side
                        If side = "DEBIT" Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 245, 245)
                        ElseIf side = "CREDIT" Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(245, 255, 245)
                        End If
                        
                        ' Bold totals
                        If accountName?.Contains("TOTAL") Then
                            row.DefaultCellStyle.Font = New Font(dgvBalanceSheet.Font, FontStyle.Bold)
                        End If
                    End If
                Next
            End If
        End Sub

        Private Sub BtnRefreshPL_Click(sender As Object, e As EventArgs) Handles btnRefreshPL.Click
            LoadProfitAndLoss()
        End Sub

        Private Sub BtnRefreshBS_Click(sender As Object, e As EventArgs) Handles btnRefreshBS.Click
            LoadBalanceSheet()
        End Sub

        Private Sub DtpPLFromDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpPLFromDate.ValueChanged
            LoadProfitAndLoss()
        End Sub

        Private Sub DtpPLToDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpPLToDate.ValueChanged
            LoadProfitAndLoss()
        End Sub

        Private Sub DtpBSAsOfDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpBSAsOfDate.ValueChanged
            LoadBalanceSheet()
        End Sub

        Private Sub CboBranchPL_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboBranchPL.SelectedIndexChanged
            LoadProfitAndLoss()
        End Sub

        Private Sub CboBranchBS_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboBranchBS.SelectedIndexChanged
            LoadBalanceSheet()
        End Sub
    End Class
End Namespace
