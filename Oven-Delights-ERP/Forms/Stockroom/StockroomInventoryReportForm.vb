Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing
Imports System.Configuration

Namespace Stockroom

    Public Class StockroomInventoryReportForm
        Inherits Form

        Private dgvInventory As DataGridView
        Private btnRefresh As Button
        Private btnPrint As Button
        Private btnExport As Button
        Private lblTitle As Label
        Private lblSummary As Label

        Public Sub New()
            InitializeComponent()
            Try
                LoadInventory()
            Catch ex As Exception
                MessageBox.Show("Error initializing report: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Stockroom Inventory Report"
            Me.Size = New Size(1200, 700)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Font = New Font("Segoe UI", 9.0F)

            ' Title
            lblTitle = New Label() With {
                .Text = "📦 STOCKROOM INVENTORY",
                .Left = 20,
                .Top = 20,
                .Width = 1160,
                .Height = 40,
                .Font = New Font("Segoe UI", 18.0F, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94),
                .TextAlign = ContentAlignment.MiddleCenter
            }

            ' Summary
            lblSummary = New Label() With {
                .Left = 20,
                .Top = 70,
                .Width = 1160,
                .Height = 25,
                .Font = New Font("Segoe UI", 10.0F),
                .ForeColor = Color.FromArgb(127, 140, 141),
                .TextAlign = ContentAlignment.MiddleCenter
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
                    .BackColor = Color.FromArgb(52, 73, 94),
                    .ForeColor = Color.White,
                    .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
                    .Alignment = DataGridViewContentAlignment.MiddleCenter
                },
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {
                    .BackColor = Color.FromArgb(236, 240, 241)
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

            Me.Controls.AddRange(New Control() {lblTitle, lblSummary, dgvInventory, btnRefresh, btnPrint, btnExport})
        End Sub

        Private Sub LoadInventory()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    Dim sql As String = _
                        "SELECT " & _
                        "    rm.MaterialCode AS [Code], " & _
                        "    rm.MaterialName AS [Material Name], " & _
                        "    cat.CategoryName AS [Category], " & _
                        "    rm.CurrentStock AS [Qty On Hand], " & _
                        "    rm.BaseUnit AS [UoM], " & _
                        "    rm.ReorderLevel AS [Reorder Level], " & _
                        "    CASE " & _
                        "        WHEN rm.CurrentStock <= rm.ReorderLevel THEN 'LOW STOCK' " & _
                        "        WHEN rm.CurrentStock <= (rm.ReorderLevel * 1.5) THEN 'WARNING' " & _
                        "        ELSE 'OK' " & _
                        "    END AS [Status], " & _
                        "    rm.AverageCost AS [Avg Cost], " & _
                        "    rm.CurrentStock * rm.AverageCost AS [Total Value], " & _
                        "    sup.SupplierName AS [Preferred Supplier] " & _
                        "FROM dbo.RawMaterials rm " & _
                        "LEFT JOIN dbo.MaterialCategories cat ON cat.CategoryID = rm.CategoryID " & _
                        "LEFT JOIN dbo.Suppliers sup ON sup.SupplierID = rm.PreferredSupplierID " & _
                        "ORDER BY " & _
                        "    CASE " & _
                        "        WHEN rm.CurrentStock <= rm.ReorderLevel THEN 1 " & _
                        "        WHEN rm.CurrentStock <= (rm.ReorderLevel * 1.5) THEN 2 " & _
                        "        ELSE 3 " & _
                        "    END, " & _
                        "    rm.MaterialName"

                    Using cmd As New SqlCommand(sql, cn)
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)

                            dgvInventory.DataSource = dt

                            ' Format columns
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

                            ' Color code status
                            For Each row As DataGridViewRow In dgvInventory.Rows
                                If row.Cells("Status").Value IsNot Nothing Then
                                    Dim status As String = row.Cells("Status").Value.ToString()
                                    If status = "LOW STOCK" Then
                                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 220, 220)
                                        row.DefaultCellStyle.ForeColor = Color.FromArgb(192, 57, 43)
                                    ElseIf status = "WARNING" Then
                                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 243, 205)
                                        row.DefaultCellStyle.ForeColor = Color.FromArgb(211, 84, 0)
                                    End If
                                End If
                            Next

                            ' Update summary
                            Dim totalItems As Integer = dt.Rows.Count
                            Dim totalValue As Decimal = 0D
                            Dim lowStockCount As Integer = 0

                            For Each row As DataRow In dt.Rows
                                If Not IsDBNull(row("Total Value")) Then
                                    totalValue += Convert.ToDecimal(row("Total Value"))
                                End If
                                If row("Status").ToString() = "LOW STOCK" Then
                                    lowStockCount += 1
                                End If
                            Next

                            lblSummary.Text = $"Total Items: {totalItems} | Total Value: {totalValue:C2} | Low Stock Items: {lowStockCount}"
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                MessageBox.Show("Error loading inventory: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
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
