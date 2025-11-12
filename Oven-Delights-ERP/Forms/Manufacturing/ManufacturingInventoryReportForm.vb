Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing
Imports System.Configuration

Namespace Manufacturing

    Public Class ManufacturingInventoryReportForm
        Inherits Form

        Private dgvInventory As DataGridView
        Private cboBranch As ComboBox
        Private btnRefresh As Button
        Private btnPrint As Button
        Private btnExport As Button
        Private lblTitle As Label
        Private lblSummary As Label
        Private lblBranch As Label

        Public Sub New()
            Try
                InitializeComponent()
                LoadBranches()
                LoadInventory()
            Catch ex As Exception
                MessageBox.Show("Error initializing Manufacturing Inventory Report: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Manufacturing Inventory Report"
            Me.Size = New Size(1200, 700)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Font = New Font("Segoe UI", 9.0F)

            ' Title
            lblTitle = New Label() With {
                .Text = "🏭 MANUFACTURING INVENTORY (Work-in-Progress)",
                .Left = 20,
                .Top = 20,
                .Width = 1160,
                .Height = 40,
                .Font = New Font("Segoe UI", 18.0F, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94),
                .TextAlign = ContentAlignment.MiddleCenter
            }

            ' Branch filter
            lblBranch = New Label() With {
                .Text = "Branch:",
                .Left = 20,
                .Top = 75,
                .Width = 60,
                .Height = 25,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
            }

            cboBranch = New ComboBox() With {
                .Left = 90,
                .Top = 72,
                .Width = 250,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10.0F)
            }

            ' Summary
            lblSummary = New Label() With {
                .Left = 360,
                .Top = 75,
                .Width = 820,
                .Height = 25,
                .Font = New Font("Segoe UI", 10.0F),
                .ForeColor = Color.FromArgb(127, 140, 141),
                .TextAlign = ContentAlignment.MiddleLeft
            }

            ' DataGridView
            dgvInventory = New DataGridView() With {
                .Left = 20,
                .Top = 110,
                .Width = 1160,
                .Height = 480,
                .ReadOnly = True,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.Fixed3D,
                .ColumnHeadersDefaultCellStyle = New DataGridViewCellStyle() With {
                    .BackColor = Color.FromArgb(230, 126, 34),
                    .ForeColor = Color.White,
                    .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
                    .Alignment = DataGridViewContentAlignment.MiddleCenter
                },
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {
                    .BackColor = Color.FromArgb(254, 249, 231)
                }
            }

            ' Buttons
            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Left = 20,
                .Top = 610,
                .Width = 120,
                .Height = 40,
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
            }
            btnRefresh.FlatAppearance.BorderSize = 0

            btnPrint = New Button() With {
                .Text = "🖨️ Print",
                .Left = 150,
                .Top = 610,
                .Width = 120,
                .Height = 40,
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
            }
            btnPrint.FlatAppearance.BorderSize = 0

            btnExport = New Button() With {
                .Text = "📊 Export",
                .Left = 280,
                .Top = 610,
                .Width = 120,
                .Height = 40,
                .BackColor = Color.FromArgb(155, 89, 182),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
            }
            btnExport.FlatAppearance.BorderSize = 0

            AddHandler btnRefresh.Click, AddressOf OnRefresh
            AddHandler btnPrint.Click, AddressOf OnPrint
            AddHandler btnExport.Click, AddressOf OnExport
            AddHandler cboBranch.SelectedIndexChanged, AddressOf OnBranchChanged

            Me.Controls.AddRange(New Control() {lblTitle, lblBranch, cboBranch, lblSummary, dgvInventory, btnRefresh, btnPrint, btnExport})
        End Sub

        Private Sub LoadBranches()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql = "SELECT BranchID, BranchName FROM dbo.Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Using cmd As New SqlCommand(sql, cn)
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)

                            ' Add "All Branches" option
                            Dim allRow = dt.NewRow()
                            allRow("BranchID") = 0
                            allRow("BranchName") = "All Branches"
                            dt.Rows.InsertAt(allRow, 0)

                            cboBranch.DisplayMember = "BranchName"
                            cboBranch.ValueMember = "BranchID"
                            cboBranch.DataSource = dt

                            ' Select current branch or all
                            If AppSession.CurrentBranchID > 0 Then
                                cboBranch.SelectedValue = AppSession.CurrentBranchID
                            Else
                                cboBranch.SelectedIndex = 0
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadInventory()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    Dim branchFilter As String = ""
                    If cboBranch IsNot Nothing AndAlso cboBranch.SelectedValue IsNot Nothing Then
                        Dim branchID As Integer = Convert.ToInt32(cboBranch.SelectedValue)
                        If branchID > 0 Then
                            branchFilter = " AND mi.BranchID = @branchId"
                        End If
                    End If

                    Dim sql As String = _
                        "SELECT " & _
                        "    b.BranchName AS [Branch], " & _
                        "    rm.MaterialCode AS [Code], " & _
                        "    rm.MaterialName AS [Material Name], " & _
                        "    cat.CategoryName AS [Category], " & _
                        "    mi.QtyOnHand AS [Qty On Hand], " & _
                        "    rm.BaseUnit AS [UoM], " & _
                        "    mi.AverageCost AS [Avg Cost], " & _
                        "    mi.QtyOnHand * mi.AverageCost AS [Total Value], " & _
                        "    mi.LastUpdated AS [Last Updated], " & _
                        "    u.Username AS [Updated By] " & _
                        "FROM dbo.Manufacturing_Inventory mi " & _
                        "INNER JOIN dbo.RawMaterials rm ON rm.MaterialID = mi.MaterialID " & _
                        "INNER JOIN dbo.Branches b ON b.BranchID = mi.BranchID " & _
                        "LEFT JOIN dbo.MaterialCategories cat ON cat.CategoryID = rm.CategoryID " & _
                        "LEFT JOIN dbo.Users u ON u.UserID = mi.UpdatedBy " & _
                        "WHERE mi.QtyOnHand > 0" & branchFilter & " " & _
                        "ORDER BY b.BranchName, rm.MaterialName"

                    Using cmd As New SqlCommand(sql, cn)
                        If branchFilter <> "" Then
                            cmd.Parameters.AddWithValue("@branchId", cboBranch.SelectedValue)
                        End If

                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)

                            dgvInventory.DataSource = dt

                            ' Format columns - check if they exist first
                            Try
                                If dgvInventory.Columns.Contains("Qty On Hand") Then
                                    dgvInventory.Columns("Qty On Hand").DefaultCellStyle.Format = "N2"
                                    dgvInventory.Columns("Qty On Hand").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                                End If

                                If dgvInventory.Columns.Contains("Avg Cost") Then
                                    dgvInventory.Columns("Avg Cost").DefaultCellStyle.Format = "C2"
                                    dgvInventory.Columns("Avg Cost").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                                End If

                                If dgvInventory.Columns.Contains("Total Value") Then
                                    dgvInventory.Columns("Total Value").DefaultCellStyle.Format = "C2"
                                    dgvInventory.Columns("Total Value").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                                End If

                                If dgvInventory.Columns.Contains("Last Updated") Then
                                    dgvInventory.Columns("Last Updated").DefaultCellStyle.Format = "yyyy-MM-dd HH:mm"
                                End If
                            Catch ex As Exception
                                ' Column formatting failed - non-fatal
                                System.Diagnostics.Debug.WriteLine("Column formatting error: " & ex.Message)
                            End Try

                            ' Update summary
                            Dim totalItems As Integer = dt.Rows.Count
                            Dim totalValue As Decimal = 0D

                            For Each row As DataRow In dt.Rows
                                If Not IsDBNull(row("Total Value")) Then
                                    totalValue += Convert.ToDecimal(row("Total Value"))
                                End If
                            Next

                            lblSummary.Text = $"Total Items: {totalItems} | Total Value: {totalValue:C2}"
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                MessageBox.Show("Error loading inventory: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnBranchChanged(sender As Object, e As EventArgs)
            LoadInventory()
        End Sub

        Private Sub OnRefresh(sender As Object, e As EventArgs)
            LoadInventory()
        End Sub

        Private Sub OnPrint(sender As Object, e As EventArgs)
            MessageBox.Show("Print functionality - to be implemented", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OnExport(sender As Object, e As EventArgs)
            MessageBox.Show("Export functionality - to be implemented", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

    End Class

End Namespace
