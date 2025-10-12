Imports System.Windows.Forms
Imports System.Drawing

Public Class PayrollJournalForm
    Inherits Form

    Private ReadOnly dtPeriod As New DateTimePicker() With {.Format = DateTimePickerFormat.Short}
    Private ReadOnly numGross As New NumericUpDown() With {.DecimalPlaces = 2, .Maximum = Decimal.MaxValue, .ThousandsSeparator = True, .Increment = 10D}
    Private ReadOnly numDeductions As New NumericUpDown() With {.DecimalPlaces = 2, .Maximum = Decimal.MaxValue, .ThousandsSeparator = True, .Increment = 10D}
    Private ReadOnly txtReference As New TextBox()
    Private ReadOnly btnPostAccrual As New Button() With {.Text = "Post Payroll Accrual"}
    Private ReadOnly btnPostPayment As New Button() With {.Text = "Post Payroll Payment"}

    Public Sub New()
        Me.Text = "Payroll Journal"
        Me.Width = 760
        Me.Height = 360
        Me.BackColor = Color.White

        ' Root container to control docking order reliably
        Dim root As New Panel() With {.Dock = DockStyle.Fill, .BackColor = Me.BackColor}

        ' Removed blue header banner; add a small spacer for breathing room
        root.Controls.Add(New Panel() With {.Dock = DockStyle.Top, .Height = 12})

        Dim layout As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .ColumnCount = 2, .RowCount = 6, .Padding = New Padding(12)}
        layout.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 35))
        layout.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 65))
        layout.Controls.Add(New Label() With {.Text = "Period Date:", .AutoSize = True}, 0, 0)
        layout.Controls.Add(dtPeriod, 1, 0)
        layout.Controls.Add(New Label() With {.Text = "Reference:", .AutoSize = True}, 0, 1)
        layout.Controls.Add(txtReference, 1, 1)
        layout.Controls.Add(New Label() With {.Text = "Gross Payroll (total):", .AutoSize = True}, 0, 2)
        layout.Controls.Add(numGross, 1, 2)
        layout.Controls.Add(New Label() With {.Text = "Deductions (PAYE/UIF/etc):", .AutoSize = True}, 0, 3)
        layout.Controls.Add(numDeductions, 1, 3)
        Dim help As New Label() With {
            .Text = "Accrual: DR Payroll Expense, CR Payroll Liability (gross). Payment: DR Liability, CR Bank (net).",
            .AutoSize = True,
            .ForeColor = Color.FromArgb(90,90,90)
        }
        layout.Controls.Add(help, 1, 4)

        Dim btns As New FlowLayoutPanel() With {.Dock = DockStyle.Fill}
        btns.Controls.Add(btnPostAccrual)
        btns.Controls.Add(btnPostPayment)
        layout.Controls.Add(btns, 1, 5)
        root.Controls.Add(layout)
        Controls.Add(root)

        ' Button colors
        btnPostAccrual.BackColor = Color.FromArgb(0, 158, 73)
        btnPostAccrual.ForeColor = Color.White
        btnPostAccrual.FlatStyle = FlatStyle.Flat
        btnPostAccrual.FlatAppearance.BorderSize = 0

        btnPostPayment.BackColor = Color.FromArgb(183, 58, 46)
        btnPostPayment.ForeColor = Color.White
        btnPostPayment.FlatStyle = FlatStyle.Flat
        btnPostPayment.FlatAppearance.BorderSize = 0

        AddHandler btnPostAccrual.Click, AddressOf OnPostAccrual
        AddHandler btnPostPayment.Click, AddressOf OnPostPayment
    End Sub

    Private Sub OnPostAccrual(sender As Object, e As EventArgs)
        Try
            Dim svc As New PayrollService()
            Dim jId = svc.AccruePayroll(dtPeriod.Value, txtReference.Text, numGross.Value, numDeductions.Value, AppSession.CurrentUserID, AppSession.CurrentBranchID)
            MessageBox.Show($"Payroll accrual posted. Journal ID: {jId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnPostPayment(sender As Object, e As EventArgs)
        Try
            Dim svc As New PayrollService()
            Dim jId = svc.PayPayroll(dtPeriod.Value, txtReference.Text, numGross.Value - numDeductions.Value, AppSession.CurrentUserID, AppSession.CurrentBranchID)
            MessageBox.Show($"Payroll payment posted. Journal ID: {jId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
