Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms

    Public Class TransferOrdersListForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34)
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0)
        Private ReadOnly ColorLight As Color = Color.FromArgb(245, 222, 179)

        Private dgvTransfers As DataGridView
        Private cmbStatusFilter As ComboBox
        Private btnRefresh As Button
        Private btnDispatch As Button
        Private btnReceive As Button
        Private btnClose As Button

        Public Sub New()
            Try
                Me.Text = "Inter-Branch Transfer Orders - Oven Delights"
                Me.Width = 1400
                Me.Height = 800
                Me.StartPosition = FormStartPosition.CenterScreen
                Me.BackColor = Color.White
                InitializeUI()
                LoadTransfers()
            Catch ex As Exception
                MessageBox.Show($"Error initializing form: {ex.Message}{vbCrLf}{vbCrLf}{ex.StackTrace}", "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorDark
            }
            
            Dim lblHeader As New Label() With {
                .Text = "📦 Transfer Orders",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 30,
                .Top = 30
            }
            
            Dim lblSubHeader As New Label() With {
                .Text = "View and manage inter-branch transfers",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Left = 30,
                .Top = 62
            }
            
            pnlHeader.Controls.AddRange({lblHeader, lblSubHeader})

            ' Filter Panel
            Dim pnlFilter As New Panel() With {
                .Left = 30,
                .Top = 120,
                .Width = 1340,
                .Height = 60,
                .BackColor = Color.White
            }

            Dim lblStatus As New Label() With {
                .Text = "Status Filter:",
                .Left = 0,
                .Top = 15,
                .Width = 100,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            cmbStatusFilter = New ComboBox() With {
                .Left = 110,
                .Top = 12,
                .Width = 200,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            cmbStatusFilter.Items.AddRange({"All", "Pending", "In Transit", "Received", "Cancelled"})
            cmbStatusFilter.SelectedIndex = 0
            AddHandler cmbStatusFilter.SelectedIndexChanged, AddressOf OnFilterChanged

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Left = 330,
                .Top = 10,
                .Width = 120,
                .Height = 35,
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRefresh.FlatAppearance.BorderSize = 0
            AddHandler btnRefresh.Click, Sub(s, ev) LoadTransfers()

            pnlFilter.Controls.AddRange({lblStatus, cmbStatusFilter, btnRefresh})

            ' DataGridView
            dgvTransfers = New DataGridView() With {
                .Left = 30,
                .Top = 200,
                .Width = 1340,
                .Height = 450,
                .BackgroundColor = Color.White,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 9)
            }

            ' Button Panel
            Dim pnlButtons As New Panel() With {
                .Left = 30,
                .Top = 670,
                .Width = 1340,
                .Height = 60,
                .BackColor = Color.White
            }

            btnDispatch = New Button() With {
                .Text = "📤 Dispatch",
                .Left = 0,
                .Top = 10,
                .Width = 150,
                .Height = 40,
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnDispatch.FlatAppearance.BorderSize = 0
            AddHandler btnDispatch.Click, AddressOf BtnDispatch_Click

            btnReceive = New Button() With {
                .Text = "📥 Receive",
                .Left = 170,
                .Top = 10,
                .Width = 150,
                .Height = 40,
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnReceive.FlatAppearance.BorderSize = 0
            AddHandler btnReceive.Click, AddressOf BtnReceive_Click

            btnClose = New Button() With {
                .Text = "Close",
                .Left = 1190,
                .Top = 10,
                .Width = 150,
                .Height = 40,
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnClose.FlatAppearance.BorderSize = 0
            AddHandler btnClose.Click, Sub(s, ev) Me.Close()

            pnlButtons.Controls.AddRange({btnDispatch, btnReceive, btnClose})

            Me.Controls.Add(pnlButtons)
            Me.Controls.Add(dgvTransfers)
            Me.Controls.Add(pnlFilter)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadTransfers()
            Try
                ' Show loading message
                Me.Text = "Loading transfers..."
                
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT 
                        t.TransferID,
                        t.TransferNumber,
                        t.CreatedDate AS TransferDate,
                        fb.BranchName AS FromBranch,
                        tb.BranchName AS ToBranch,
                        p.Name AS ProductName,
                        t.Quantity,
                        t.UnitCost,
                        t.TotalValue,
                        t.Status,
                        t.CreatedDate,
                        u.Username AS CreatedBy
                    FROM InterBranchTransfers t
                    INNER JOIN Branches fb ON t.FromBranchID = fb.BranchID
                    INNER JOIN Branches tb ON t.ToBranchID = tb.BranchID
                    INNER JOIN demo_Retail_product p ON t.ProductID = p.ProductID
                    INNER JOIN Users u ON t.CreatedBy = u.UserID
                    WHERE (@Status = 'All' OR t.Status = @Status)
                    ORDER BY t.CreatedDate DESC, t.TransferID DESC"

                    Using cmd As New SqlCommand(sql, con)
                        Dim statusFilter As String = If(cmbStatusFilter.SelectedItem IsNot Nothing, cmbStatusFilter.SelectedItem.ToString(), "All")
                        cmd.Parameters.AddWithValue("@Status", statusFilter)
                        
                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvTransfers.DataSource = dt

                        ' Format columns
                        If dgvTransfers.Columns.Count > 0 Then
                            dgvTransfers.Columns("TransferID").Visible = False
                            dgvTransfers.Columns("TransferNumber").HeaderText = "Transfer #"
                            dgvTransfers.Columns("TransferDate").HeaderText = "Date"
                            dgvTransfers.Columns("FromBranch").HeaderText = "From"
                            dgvTransfers.Columns("ToBranch").HeaderText = "To"
                            dgvTransfers.Columns("ProductName").HeaderText = "Product"
                            dgvTransfers.Columns("Quantity").HeaderText = "Qty"
                            dgvTransfers.Columns("UnitCost").HeaderText = "Unit Cost"
                            dgvTransfers.Columns("UnitCost").DefaultCellStyle.Format = "C2"
                            dgvTransfers.Columns("TotalValue").HeaderText = "Total"
                            dgvTransfers.Columns("TotalValue").DefaultCellStyle.Format = "C2"
                            dgvTransfers.Columns("Status").HeaderText = "Status"
                            dgvTransfers.Columns("CreatedDate").HeaderText = "Created"
                            dgvTransfers.Columns("CreatedBy").HeaderText = "Created By"

                            ' Color code status
                            For Each row As DataGridViewRow In dgvTransfers.Rows
                                Dim status As String = row.Cells("Status").Value.ToString()
                                Select Case status
                                    Case "Pending"
                                        row.Cells("Status").Style.BackColor = Color.LightYellow
                                    Case "In Transit"
                                        row.Cells("Status").Style.BackColor = Color.LightBlue
                                    Case "Received"
                                        row.Cells("Status").Style.BackColor = Color.LightGreen
                                    Case "Cancelled"
                                        row.Cells("Status").Style.BackColor = Color.LightGray
                                End Select
                            Next
                        End If
                    End Using
                End Using
                
                ' Reset title
                Me.Text = "Inter-Branch Transfer Orders - Oven Delights"
            Catch ex As Exception
                MessageBox.Show($"Error loading transfers: {ex.Message}{vbCrLf}{vbCrLf}Stack: {ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.Text = "Inter-Branch Transfer Orders - ERROR"
            End Try
        End Sub

        Private Sub OnFilterChanged(sender As Object, e As EventArgs)
            LoadTransfers()
        End Sub

        Private Sub BtnDispatch_Click(sender As Object, e As EventArgs)
            If dgvTransfers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a transfer to dispatch.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim transferId As Integer = Convert.ToInt32(dgvTransfers.SelectedRows(0).Cells("TransferID").Value)
            Dim status As String = dgvTransfers.SelectedRows(0).Cells("Status").Value.ToString()

            If status <> "Pending" Then
                MessageBox.Show("Only transfers with 'Pending' status can be dispatched.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim dispatchForm As New TransferDispatchForm(transferId)
            If dispatchForm.ShowDialog() = DialogResult.OK Then
                LoadTransfers()
            End If
        End Sub

        Private Sub BtnReceive_Click(sender As Object, e As EventArgs)
            If dgvTransfers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a transfer to receive.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim transferId As Integer = Convert.ToInt32(dgvTransfers.SelectedRows(0).Cells("TransferID").Value)
            Dim status As String = dgvTransfers.SelectedRows(0).Cells("Status").Value.ToString()

            If status <> "In Transit" Then
                MessageBox.Show("Only transfers with 'In Transit' status can be received.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim receiveForm As New TransferReceiveForm(transferId)
            If receiveForm.ShowDialog() = DialogResult.OK Then
                LoadTransfers()
            End If
        End Sub

    End Class

End Namespace
