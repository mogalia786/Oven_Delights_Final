Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class ProfitLossReportForm
    Inherits Form

    Private ReadOnly _glService As New GeneralLedgerService()

    Public Sub New()
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Profit & Loss Statement"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)

        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Title
        Dim lblTitle As New Label With {
            .Text = "Profit & Loss Statement",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .Dock = DockStyle.Top,
            .Height = 50,
            .ForeColor = Color.FromArgb(39, 174, 96),
            .TextAlign = ContentAlignment.MiddleLeft
        }

        ' Filter Panel
        Dim pnlFilter As New Panel With {.Dock = DockStyle.Top, .Height = 80, .BackColor = Color.White}

        Dim lblFrom As New Label With {.Text = "From:", .Location = New Point(20, 25), .Width = 50}
        Dim dtpFrom As New DateTimePicker With {
            .Location = New Point(80, 22),
            .Width = 150,
            .Name = "dtpFrom",
            .Value = New Date(DateTime.Now.Year, 1, 1)
        }

        Dim lblTo As New Label With {.Text = "To:", .Location = New Point(250, 25), .Width = 30}
        Dim dtpTo As New DateTimePicker With {
            .Location = New Point(290, 22),
            .Width = 150,
            .Name = "dtpTo"
        }

        Dim btnGenerate As New Button With {
            .Text = "Generate Report",
            .Location = New Point(460, 20),
            .Size = New Size(150, 35),
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnGenerate.FlatAppearance.BorderSize = 0
        AddHandler btnGenerate.Click, AddressOf BtnGenerate_Click

        pnlFilter.Controls.AddRange({lblFrom, dtpFrom, lblTo, dtpTo, btnGenerate})

        ' DataGridView
        Dim dgvReport As New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .Name = "dgvReport",
            .RowHeadersVisible = False,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Font = New Font("Segoe UI", 10),
                .SelectionBackColor = Color.FromArgb(39, 174, 96),
                .SelectionForeColor = Color.White
            },
            .ColumnHeadersDefaultCellStyle = New DataGridViewCellStyle With {
                .BackColor = Color.FromArgb(52, 73, 94),
                .ForeColor = Color.White,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Padding = New Padding(5)
            },
            .EnableHeadersVisualStyles = False,
            .RowTemplate = New DataGridViewRow With {.Height = 35}
        }

        ' Summary Panel
        Dim pnlSummary As New Panel With {.Dock = DockStyle.Bottom, .Height = 100, .BackColor = Color.FromArgb(236, 240, 241)}
        Dim lblGrossProfit As New Label With {
            .Name = "lblGrossProfit",
            .Location = New Point(20, 10),
            .Width = 400,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        Dim lblNetProfit As New Label With {
            .Name = "lblNetProfit",
            .Location = New Point(20, 40),
            .Width = 400,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold)
        }
        pnlSummary.Controls.AddRange({lblGrossProfit, lblNetProfit})

        pnlMain.Controls.Add(dgvReport)
        pnlMain.Controls.Add(pnlSummary)
        pnlMain.Controls.Add(pnlFilter)
        pnlMain.Controls.Add(lblTitle)
        Me.Controls.Add(pnlMain)
    End Sub

    Private Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim dtpFrom = CType(pnlMain.Controls("dtpFrom"), DateTimePicker)
            Dim dtpTo = CType(pnlMain.Controls("dtpTo"), DateTimePicker)
            Dim dgv = CType(pnlMain.Controls("dgvReport"), DataGridView)

            Dim dt = _glService.GetProfitLoss(dtpFrom.Value, dtpTo.Value, Nothing)
            dgv.DataSource = dt

            If dt.Rows.Count > 0 Then
                ' Format columns
                dgv.Columns("Section").HeaderText = "Section"
                dgv.Columns("Section").Width = 150
                dgv.Columns("AccountCode").HeaderText = "Code"
                dgv.Columns("AccountCode").Width = 100
                dgv.Columns("AccountName").HeaderText = "Account"
                dgv.Columns("Amount").HeaderText = "Amount"
                dgv.Columns("Amount").DefaultCellStyle.Format = "N2"
                dgv.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("Amount").Width = 150

                ' Color-code by section
                For Each row As DataGridViewRow In dgv.Rows
                    Dim section = row.Cells("Section").Value.ToString()
                    Select Case section
                        Case "Revenue"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(234, 250, 241)
                            row.Cells("Section").Style.ForeColor = Color.FromArgb(39, 174, 96)
                            row.Cells("Section").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        Case "Cost of Sales"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(254, 249, 231)
                            row.Cells("Section").Style.ForeColor = Color.FromArgb(243, 156, 18)
                            row.Cells("Section").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        Case "Expenses"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(253, 237, 236)
                            row.Cells("Section").Style.ForeColor = Color.FromArgb(192, 57, 43)
                            row.Cells("Section").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                    End Select
                Next

                ' Calculate P&L
                Dim revenue = dt.AsEnumerable().Where(Function(r) r("Section").ToString() = "Revenue").Sum(Function(r) CDec(r("Amount")))
                Dim cogs = dt.AsEnumerable().Where(Function(r) r("Section").ToString() = "Cost of Sales").Sum(Function(r) CDec(r("Amount")))
                Dim expenses = dt.AsEnumerable().Where(Function(r) r("Section").ToString() = "Expenses").Sum(Function(r) CDec(r("Amount")))

                Dim grossProfit = revenue - cogs
                Dim netProfit = grossProfit - expenses

                Dim lblGross = CType(pnlMain.Controls("lblGrossProfit"), Label)
                Dim lblNet = CType(pnlMain.Controls("lblNetProfit"), Label)
                lblGross.Text = $"Gross Profit: R {grossProfit:N2}"
                lblNet.Text = $"Net Profit: R {netProfit:N2}"

                lblNet.ForeColor = If(netProfit >= 0, Color.Green, Color.Red)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
