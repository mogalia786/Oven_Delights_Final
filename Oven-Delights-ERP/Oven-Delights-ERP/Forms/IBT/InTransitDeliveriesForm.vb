Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for viewing In Transit deliveries
    ''' Shows deliveries dispatched but not yet received
    ''' </summary>
    Public Class InTransitDeliveriesForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private _currentBranchId As Integer

        ' UI Controls
        Private dgvDeliveries As DataGridView
        Private btnRefresh As Button
        Private btnReceive As Button
        Private btnClose As Button
        Private lblTotal As Label

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New()
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)

            Me.Text = "In Transit Deliveries"
            Me.Width = 1400
            Me.Height = 800
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            InitializeUI()
            LoadDeliveries()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorDark
            }

            Dim lblTitle As New Label With {
                .Text = "🚚 In Transit Deliveries",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(30, 20)
            }

            Dim lblSubtitle As New Label With {
                .Text = "View deliveries dispatched to your branch",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Location = New Point(30, 55)
            }

            pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})

            ' Toolbar
            Dim pnlToolbar As New Panel With {
                .Location = New Point(30, 120),
                .Size = New Size(1340, 60),
                .BackColor = ColorLight
            }

            btnRefresh = New Button With {
                .Text = "🔄 Refresh",
                .Location = New Point(15, 10),
                .Size = New Size(120, 40),
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRefresh.FlatAppearance.BorderSize = 0
            AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click

            lblTotal = New Label With {
                .Text = "Total: 0 deliveries",
                .Location = New Point(155, 20),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = ColorDark
            }

            pnlToolbar.Controls.AddRange({btnRefresh, lblTotal})

            ' Grid
            dgvDeliveries = New DataGridView With {
                .Location = New Point(30, 200),
                .Size = New Size(1340, 500),
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

            dgvDeliveries.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvDeliveries.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvDeliveries.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvDeliveries.ColumnHeadersHeight = 40
            dgvDeliveries.AlternatingRowsDefaultCellStyle.BackColor = ColorLight
            dgvDeliveries.RowTemplate.Height = 35

            ' Footer
            Dim pnlFooter As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 80,
                .BackColor = ColorLight
            }

            btnReceive = New Button With {
                .Text = "📥 Receive Delivery",
                .Location = New Point(1040, 20),
                .Size = New Size(180, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnReceive.FlatAppearance.BorderSize = 0
            AddHandler btnReceive.Click, AddressOf BtnReceive_Click

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

            pnlFooter.Controls.AddRange({btnReceive, btnClose})

            Me.Controls.AddRange({pnlHeader, pnlToolbar, dgvDeliveries, pnlFooter})
        End Sub

        Private Sub LoadDeliveries()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    Dim sql = "SELECT dn.DeliveryNoteID, dn.DeliveryNoteNumber, dn.DispatchDate, 
                                     fb.BranchName AS FromBranch, p.Name AS ProductName, 
                                     dn.Quantity, dn.UnitCost, dn.TotalValue, dn.Status, 
                                     po.PONumber, dn.Notes
                              FROM InternalDeliveryNotes dn
                              INNER JOIN Branches fb ON dn.FromBranchID = fb.BranchID
                              INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
                              INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
                              WHERE dn.ToBranchID = @BranchID AND dn.Status = 'In Transit'
                              ORDER BY dn.DispatchDate DESC"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)

                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvDeliveries.DataSource = dt

                        If dgvDeliveries.Columns.Count > 0 Then
                            dgvDeliveries.Columns("DeliveryNoteID").Visible = False
                            dgvDeliveries.Columns("DeliveryNoteNumber").HeaderText = "Delivery Note #"
                            dgvDeliveries.Columns("PONumber").HeaderText = "PO Number"
                            dgvDeliveries.Columns("DispatchDate").HeaderText = "Dispatch Date"
                            dgvDeliveries.Columns("DispatchDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
                            dgvDeliveries.Columns("FromBranch").HeaderText = "From Branch"
                            dgvDeliveries.Columns("ProductName").HeaderText = "Product"
                            dgvDeliveries.Columns("Quantity").HeaderText = "Qty"
                            dgvDeliveries.Columns("Quantity").DefaultCellStyle.Format = "N2"
                            dgvDeliveries.Columns("Quantity").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvDeliveries.Columns("UnitCost").HeaderText = "Unit Cost"
                            dgvDeliveries.Columns("UnitCost").DefaultCellStyle.Format = "C2"
                            dgvDeliveries.Columns("TotalValue").HeaderText = "Total Value"
                            dgvDeliveries.Columns("TotalValue").DefaultCellStyle.Format = "C2"
                            dgvDeliveries.Columns("Status").HeaderText = "Status"
                            dgvDeliveries.Columns("Status").DefaultCellStyle.BackColor = Color.LightBlue
                            dgvDeliveries.Columns("Notes").HeaderText = "Notes"
                        End If

                        lblTotal.Text = $"Total: {dt.Rows.Count} deliveries"
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading deliveries: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
            LoadDeliveries()
        End Sub

        Private Sub BtnReceive_Click(sender As Object, e As EventArgs)
            If dgvDeliveries.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a delivery to receive.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim deliveryNoteId As Integer = Convert.ToInt32(dgvDeliveries.SelectedRows(0).Cells("DeliveryNoteID").Value)

            ' Open receive form
            Dim receiveForm As New ReceiveDeliveryForm(deliveryNoteId)
            If receiveForm.ShowDialog(Me) = DialogResult.OK Then
                LoadDeliveries()
            End If
        End Sub
    End Class
End Namespace
