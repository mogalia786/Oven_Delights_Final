Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for viewing delivered items history
    ''' Shows Date, PO Number, Delivery Note, Date Received
    ''' </summary>
    Public Class DeliveredItemsForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private _currentBranchId As Integer

        ' UI Controls
        Private dgvDelivered As DataGridView
        Private dtpFrom As DateTimePicker
        Private dtpTo As DateTimePicker
        Private cboFilterType As ComboBox
        Private btnFilter As Button
        Private btnExport As Button
        Private btnClose As Button
        Private lblTotal As Label
        Private lblTotalValue As Label

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New()
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)

            Me.Text = "Delivered Items History"
            Me.Width = 1400
            Me.Height = 800
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            InitializeUI()
            LoadDelivered()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorDark
            }

            Dim lblTitle As New Label With {
                .Text = "📦 Delivered Items History",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(30, 20)
            }

            Dim lblSubtitle As New Label With {
                .Text = "View all received deliveries",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Location = New Point(30, 55)
            }

            pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})

            ' Filter Panel
            Dim pnlFilter As New Panel With {
                .Location = New Point(30, 120),
                .Size = New Size(1340, 70),
                .BackColor = ColorLight
            }

            Dim lblFrom As New Label With {
                .Text = "From:",
                .Location = New Point(15, 20),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            dtpFrom = New DateTimePicker With {
                .Location = New Point(70, 17),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Font = New Font("Segoe UI", 10),
                .Value = DateTime.Now.AddMonths(-1)
            }

            Dim lblTo As New Label With {
                .Text = "To:",
                .Location = New Point(240, 20),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            dtpTo = New DateTimePicker With {
                .Location = New Point(275, 17),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Font = New Font("Segoe UI", 10),
                .Value = DateTime.Now
            }

            Dim lblFilter As New Label With {
                .Text = "Show:",
                .Location = New Point(445, 20),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            cboFilterType = New ComboBox With {
                .Location = New Point(505, 17),
                .Width = 200,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            cboFilterType.Items.AddRange({"All Deliveries", "Received by Me", "From Specific Branch"})
            cboFilterType.SelectedIndex = 0

            btnFilter = New Button With {
                .Text = "🔍 Filter",
                .Location = New Point(725, 12),
                .Size = New Size(120, 40),
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnFilter.FlatAppearance.BorderSize = 0
            AddHandler btnFilter.Click, AddressOf BtnFilter_Click

            btnExport = New Button With {
                .Text = "📊 Export",
                .Location = New Point(860, 12),
                .Size = New Size(120, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnExport.FlatAppearance.BorderSize = 0
            AddHandler btnExport.Click, AddressOf BtnExport_Click

            pnlFilter.Controls.AddRange({lblFrom, dtpFrom, lblTo, dtpTo, lblFilter, cboFilterType, btnFilter, btnExport})

            ' Grid
            dgvDelivered = New DataGridView With {
                .Location = New Point(30, 210),
                .Size = New Size(1340, 470),
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.FixedSingle,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 10),
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            }

            dgvDelivered.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvDelivered.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvDelivered.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvDelivered.ColumnHeadersHeight = 40
            dgvDelivered.AlternatingRowsDefaultCellStyle.BackColor = ColorLight
            dgvDelivered.RowTemplate.Height = 35

            ' Footer
            Dim pnlFooter As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 80,
                .BackColor = ColorLight
            }

            lblTotal = New Label With {
                .Text = "Total Deliveries: 0",
                .Location = New Point(30, 20),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = ColorDark
            }

            lblTotalValue = New Label With {
                .Text = "Total Value: R 0.00",
                .Location = New Point(30, 45),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorSuccess
            }

            btnClose = New Button With {
                .Text = "Close",
                .Location = New Point(1230, 20),
                .Size = New Size(140, 40),
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnClose.FlatAppearance.BorderSize = 0
            AddHandler btnClose.Click, Sub() Me.Close()

            pnlFooter.Controls.AddRange({lblTotal, lblTotalValue, btnClose})

            Me.Controls.AddRange({pnlHeader, pnlFilter, dgvDelivered, pnlFooter})
        End Sub

        Private Sub LoadDelivered()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    Dim sql = "SELECT dn.DeliveryNoteID, dn.DeliveryNoteNumber, po.PONumber, 
                                     dn.DispatchDate, dn.ReceiveDate, 
                                     fb.BranchName AS FromBranch, p.Name AS ProductName, 
                                     dn.Quantity, dn.UnitCost, dn.TotalValue, 
                                     ISNULL(u.Username, 'System') AS ReceivedBy, dn.Notes
                              FROM InternalDeliveryNotes dn
                              INNER JOIN Branches fb ON dn.FromBranchID = fb.BranchID
                              INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
                              INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
                              LEFT JOIN Users u ON dn.ReceivedBy = u.UserID
                              WHERE dn.ToBranchID = @BranchID 
                                AND dn.Status = 'Delivered'
                                AND dn.ReceiveDate BETWEEN @FromDate AND @ToDate
                              ORDER BY dn.ReceiveDate DESC"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                        cmd.Parameters.AddWithValue("@FromDate", dtpFrom.Value.Date)
                        cmd.Parameters.AddWithValue("@ToDate", dtpTo.Value.Date.AddDays(1).AddSeconds(-1))

                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvDelivered.DataSource = dt

                        If dgvDelivered.Columns.Count > 0 Then
                            dgvDelivered.Columns("DeliveryNoteID").Visible = False
                            dgvDelivered.Columns("DeliveryNoteNumber").HeaderText = "Delivery Note #"
                            dgvDelivered.Columns("PONumber").HeaderText = "PO Number"
                            dgvDelivered.Columns("DispatchDate").HeaderText = "Dispatch Date"
                            dgvDelivered.Columns("DispatchDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgvDelivered.Columns("ReceiveDate").HeaderText = "Received Date"
                            dgvDelivered.Columns("ReceiveDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
                            dgvDelivered.Columns("FromBranch").HeaderText = "From Branch"
                            dgvDelivered.Columns("ProductName").HeaderText = "Product"
                            dgvDelivered.Columns("Quantity").HeaderText = "Qty"
                            dgvDelivered.Columns("Quantity").DefaultCellStyle.Format = "N2"
                            dgvDelivered.Columns("Quantity").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvDelivered.Columns("UnitCost").HeaderText = "Unit Cost"
                            dgvDelivered.Columns("UnitCost").DefaultCellStyle.Format = "C2"
                            dgvDelivered.Columns("TotalValue").HeaderText = "Total Value"
                            dgvDelivered.Columns("TotalValue").DefaultCellStyle.Format = "C2"
                            dgvDelivered.Columns("ReceivedBy").HeaderText = "Received By"
                            dgvDelivered.Columns("Notes").HeaderText = "Notes"
                        End If

                        ' Calculate totals
                        Dim totalValue As Decimal = 0
                        For Each row As DataRow In dt.Rows
                            totalValue += Convert.ToDecimal(row("TotalValue"))
                        Next

                        lblTotal.Text = $"Total Deliveries: {dt.Rows.Count}"
                        lblTotalValue.Text = $"Total Value: R {totalValue:N2}"
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading delivered items: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnFilter_Click(sender As Object, e As EventArgs)
            LoadDelivered()
        End Sub

        Private Sub BtnExport_Click(sender As Object, e As EventArgs)
            Try
                If dgvDelivered.Rows.Count = 0 Then
                    MessageBox.Show("No data to export.", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If

                Dim sfd As New SaveFileDialog With {
                    .Filter = "CSV files (*.csv)|*.csv",
                    .FileName = $"DeliveredItems_{DateTime.Now:yyyyMMdd}.csv"
                }

                If sfd.ShowDialog() = DialogResult.OK Then
                    Dim csv As New System.Text.StringBuilder()
                    
                    ' Headers
                    Dim headers As New List(Of String)
                    For Each col As DataGridViewColumn In dgvDelivered.Columns
                        If col.Visible Then headers.Add(col.HeaderText)
                    Next
                    csv.AppendLine(String.Join(",", headers))

                    ' Data
                    For Each row As DataGridViewRow In dgvDelivered.Rows
                        Dim values As New List(Of String)
                        For Each col As DataGridViewColumn In dgvDelivered.Columns
                            If col.Visible Then
                                Dim value As String = If(row.Cells(col.Index).Value IsNot Nothing, row.Cells(col.Index).Value.ToString(), "")
                                values.Add($"""{value}""")
                            End If
                        Next
                        csv.AppendLine(String.Join(",", values))
                    Next

                    System.IO.File.WriteAllText(sfd.FileName, csv.ToString())
                    MessageBox.Show($"Data exported successfully to:{vbCrLf}{sfd.FileName}", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If

            Catch ex As Exception
                MessageBox.Show($"Error exporting data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
