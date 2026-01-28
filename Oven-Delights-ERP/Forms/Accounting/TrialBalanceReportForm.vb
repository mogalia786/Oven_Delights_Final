Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class TrialBalanceReportForm
    Inherits Form

    Private ReadOnly _glService As New GeneralLedgerService()

    Public Sub New()
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Trial Balance Report"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)

        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Title
        Dim lblTitle As New Label With {
            .Text = "Trial Balance",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .Dock = DockStyle.Top,
            .Height = 50,
            .ForeColor = Color.FromArgb(41, 128, 185),
            .TextAlign = ContentAlignment.MiddleLeft
        }

        ' Filter Panel
        Dim pnlFilter As New Panel With {.Dock = DockStyle.Top, .Height = 80, .BackColor = Color.White}

        Dim lblAsOf As New Label With {.Text = "As of Date:", .Location = New Point(20, 25), .Width = 80}
        Dim dtpAsOf As New DateTimePicker With {.Location = New Point(110, 22), .Width = 150, .Name = "dtpAsOf"}

        Dim lblBranch As New Label With {.Text = "Branch:", .Location = New Point(280, 25), .Width = 60}
        Dim cboBranch As New ComboBox With {
            .Location = New Point(350, 22),
            .Width = 200,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Name = "cboBranch"
        }
        cboBranch.Items.Add("All Branches")
        cboBranch.SelectedIndex = 0

        Dim chkZeroBalances As New CheckBox With {
            .Text = "Include Zero Balances",
            .Location = New Point(570, 25),
            .Width = 180,
            .Name = "chkZeroBalances"
        }

        Dim btnGenerate As New Button With {
            .Text = "Generate Report",
            .Location = New Point(770, 20),
            .Size = New Size(150, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnGenerate.FlatAppearance.BorderSize = 0
        AddHandler btnGenerate.Click, AddressOf BtnGenerate_Click

        pnlFilter.Controls.AddRange({lblAsOf, dtpAsOf, lblBranch, cboBranch, chkZeroBalances, btnGenerate})

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
        Dim pnlSummary As New Panel With {.Dock = DockStyle.Bottom, .Height = 60, .BackColor = Color.FromArgb(236, 240, 241)}
        Dim lblTotalDebits As New Label With {
            .Name = "lblTotalDebits",
            .Location = New Point(20, 15),
            .Width = 300,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold)
        }
        Dim lblTotalCredits As New Label With {
            .Name = "lblTotalCredits",
            .Location = New Point(350, 15),
            .Width = 300,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold)
        }
        pnlSummary.Controls.AddRange({lblTotalDebits, lblTotalCredits})

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
            Dim cboBranch = CType(pnlMain.Controls("cboBranch"), ComboBox)
            Dim chkZero = CType(pnlMain.Controls("chkZeroBalances"), CheckBox)
            Dim dgv = CType(pnlMain.Controls("dgvReport"), DataGridView)

            Dim branchId As Integer? = If(cboBranch.SelectedIndex = 0, Nothing, CInt(cboBranch.SelectedItem))

            Dim dt = _glService.GetTrialBalance(dtpAsOf.Value, branchId, chkZero.Checked)
            dgv.DataSource = dt

            If dt.Rows.Count > 0 Then
                ' Format columns
                dgv.Columns("AccountCode").HeaderText = "Code"
                dgv.Columns("AccountCode").Width = 100
                dgv.Columns("AccountName").HeaderText = "Account Name"
                dgv.Columns("AccountType").HeaderText = "Type"
                dgv.Columns("AccountType").Width = 120
                dgv.Columns("OpeningBalance").HeaderText = "Opening"
                dgv.Columns("OpeningBalance").DefaultCellStyle.Format = "N2"
                dgv.Columns("OpeningBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("TotalDebits").HeaderText = "Debits"
                dgv.Columns("TotalDebits").DefaultCellStyle.Format = "N2"
                dgv.Columns("TotalDebits").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("TotalCredits").HeaderText = "Credits"
                dgv.Columns("TotalCredits").DefaultCellStyle.Format = "N2"
                dgv.Columns("TotalCredits").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("ClosingBalance").HeaderText = "Closing"
                dgv.Columns("ClosingBalance").DefaultCellStyle.Format = "N2"
                dgv.Columns("ClosingBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight

                ' Color-code by account type
                For Each row As DataGridViewRow In dgv.Rows
                    Dim accountType = row.Cells("AccountType").Value.ToString()
                    Select Case accountType
                        Case "Asset"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(232, 248, 245)
                            row.Cells("AccountType").Style.ForeColor = Color.FromArgb(22, 160, 133)
                        Case "Liability"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(253, 237, 236)
                            row.Cells("AccountType").Style.ForeColor = Color.FromArgb(192, 57, 43)
                        Case "Equity"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(235, 245, 251)
                            row.Cells("AccountType").Style.ForeColor = Color.FromArgb(41, 128, 185)
                        Case "Revenue"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(234, 250, 241)
                            row.Cells("AccountType").Style.ForeColor = Color.FromArgb(39, 174, 96)
                        Case "Cost of Sales", "Expense"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(254, 249, 231)
                            row.Cells("AccountType").Style.ForeColor = Color.FromArgb(243, 156, 18)
                    End Select
                Next

                ' Calculate totals
                Dim totalDebits = dt.AsEnumerable().Sum(Function(r) CDec(r("TotalDebits")))
                Dim totalCredits = dt.AsEnumerable().Sum(Function(r) CDec(r("TotalCredits")))

                Dim lblDebits = CType(pnlMain.Controls("lblTotalDebits"), Label)
                Dim lblCredits = CType(pnlMain.Controls("lblTotalCredits"), Label)
                lblDebits.Text = $"Total Debits: R {totalDebits:N2}"
                lblCredits.Text = $"Total Credits: R {totalCredits:N2}"

                If totalDebits <> totalCredits Then
                    lblCredits.ForeColor = Color.Red
                    MessageBox.Show("WARNING: Trial Balance does not balance!", "Trial Balance", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Else
                    lblCredits.ForeColor = Color.Green
                End If
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
