Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class BalanceSheetReportForm
    Inherits Form

    Private ReadOnly _glService As New GeneralLedgerService()

    Public Sub New()
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Balance Sheet"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)

        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Title
        Dim lblTitle As New Label With {
            .Text = "Balance Sheet",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .Dock = DockStyle.Top,
            .Height = 50,
            .ForeColor = Color.FromArgb(41, 128, 185),
            .TextAlign = ContentAlignment.MiddleLeft
        }

        ' Filter Panel
        Dim pnlFilter As New Panel With {.Dock = DockStyle.Top, .Height = 80, .BackColor = Color.White}

        Dim lblAsOf As New Label With {.Text = "As of Date:", .Location = New Point(20, 25), .Width = 80}
        Dim dtpAsOf As New DateTimePicker With {
            .Location = New Point(110, 22),
            .Width = 150,
            .Name = "dtpAsOf"
        }

        Dim btnGenerate As New Button With {
            .Text = "Generate Report",
            .Location = New Point(280, 20),
            .Size = New Size(150, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnGenerate.FlatAppearance.BorderSize = 0
        AddHandler btnGenerate.Click, AddressOf BtnGenerate_Click

        pnlFilter.Controls.AddRange({lblAsOf, dtpAsOf, btnGenerate})

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
                .SelectionBackColor = Color.FromArgb(52, 152, 219),
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
        Dim pnlSummary As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 120,
            .BackColor = Color.FromArgb(236, 240, 241)
        }
        
        Dim lblTotalAssets As New Label With {
            .Name = "lblTotalAssets",
            .Location = New Point(20, 15),
            .Width = 400,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(39, 174, 96)
        }
        Dim lblTotalLiabilities As New Label With {
            .Name = "lblTotalLiabilities",
            .Location = New Point(20, 45),
            .Width = 400,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(231, 76, 60)
        }
        Dim lblTotalEquity As New Label With {
            .Name = "lblTotalEquity",
            .Location = New Point(20, 75),
            .Width = 400,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219)
        }
        pnlSummary.Controls.AddRange({lblTotalAssets, lblTotalLiabilities, lblTotalEquity})

        pnlMain.Controls.Add(dgvReport)
        pnlMain.Controls.Add(pnlSummary)
        pnlMain.Controls.Add(pnlFilter)
        pnlMain.Controls.Add(lblTitle)
        Me.Controls.Add(pnlMain)
    End Sub

    Private Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim dtpAsOf = CType(pnlMain.Controls("dtpAsOf"), DateTimePicker)
            Dim dgv = CType(pnlMain.Controls("dgvReport"), DataGridView)

            Dim dt = _glService.GetBalanceSheet(dtpAsOf.Value, Nothing)
            dgv.DataSource = dt

            If dt.Rows.Count > 0 Then
                ' Format columns
                dgv.Columns("Section").HeaderText = "Section"
                dgv.Columns("Section").Width = 150
                dgv.Columns("AccountCode").HeaderText = "Code"
                dgv.Columns("AccountCode").Width = 100
                dgv.Columns("AccountName").HeaderText = "Account"
                dgv.Columns("Balance").HeaderText = "Balance"
                dgv.Columns("Balance").DefaultCellStyle.Format = "N2"
                dgv.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("Balance").Width = 150

                ' Color-code sections
                For Each row As DataGridViewRow In dgv.Rows
                    Dim section = row.Cells("Section").Value.ToString()
                    Select Case section
                        Case "Assets"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(232, 248, 245)
                            row.DefaultCellStyle.ForeColor = Color.FromArgb(22, 160, 133)
                        Case "Liabilities"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(253, 237, 236)
                            row.DefaultCellStyle.ForeColor = Color.FromArgb(192, 57, 43)
                        Case "Equity"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(235, 245, 251)
                            row.DefaultCellStyle.ForeColor = Color.FromArgb(41, 128, 185)
                    End Select
                Next

                ' Calculate totals
                Dim totalAssets = dt.AsEnumerable().Where(Function(r) r("Section").ToString() = "Assets").Sum(Function(r) CDec(r("Balance")))
                Dim totalLiabilities = dt.AsEnumerable().Where(Function(r) r("Section").ToString() = "Liabilities").Sum(Function(r) CDec(r("Balance")))
                Dim totalEquity = dt.AsEnumerable().Where(Function(r) r("Section").ToString() = "Equity").Sum(Function(r) CDec(r("Balance")))

                Dim lblAssets = CType(pnlMain.Controls("lblTotalAssets"), Label)
                Dim lblLiab = CType(pnlMain.Controls("lblTotalLiabilities"), Label)
                Dim lblEquity = CType(pnlMain.Controls("lblTotalEquity"), Label)
                
                lblAssets.Text = $"Total Assets: R {totalAssets:N2}"
                lblLiab.Text = $"Total Liabilities: R {totalLiabilities:N2}"
                lblEquity.Text = $"Total Equity: R {totalEquity:N2}"

                ' Verify balance sheet equation: Assets = Liabilities + Equity
                Dim difference = Math.Abs(totalAssets - (totalLiabilities + totalEquity))
                If difference > 0.01D Then
                    MessageBox.Show($"WARNING: Balance Sheet does not balance! Difference: R {difference:N2}", 
                                  "Balance Sheet", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End If
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
