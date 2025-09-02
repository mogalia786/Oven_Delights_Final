' PayrollEntryForm.vb
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Drawing
Imports System.Windows.Forms

Public Class PayrollEntryForm
    Inherits Form

    Private ReadOnly cboUser As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList, .Width = 260}
    Private ReadOnly dtWorkDate As New DateTimePicker() With {.Format = DateTimePickerFormat.Short}
    Private ReadOnly cboBranch As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList, .Width = 200}

    Private ReadOnly txtBase As New TextBox() With {.Text = "0.00", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtAllow As New TextBox() With {.Text = "0.00", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtOT As New TextBox() With {.Text = "0.00", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtBonus As New TextBox() With {.Text = "0.00", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtDed As New TextBox() With {.Text = "0.00", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtSick As New TextBox() With {.Text = "0", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtLeave As New TextBox() With {.Text = "0", .TextAlign = HorizontalAlignment.Right}
    Private ReadOnly txtNotes As New TextBox() With {.Width = 420}

    Private ReadOnly lblGross As New Label() With {.AutoSize = True}
    Private ReadOnly lblNet As New Label() With {.AutoSize = True}

    Private ReadOnly btnSave As New Button() With {.Text = "Save Entry", .Width = 140, .Height = 32}

    ' Live summary grid for totals (declared at class level)
    Private _summaryGrid As DataGridView

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Sub New()
        Me.Text = "Payroll Entry"
        Me.Width = 860
        Me.Height = 520
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.White
        Me.AutoScroll = False

        ' Root container: TableLayoutPanel avoids Dock z-order quirks
        Dim root As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .BackColor = Me.BackColor, .ColumnCount = 1, .RowCount = 3}
        root.RowStyles.Add(New RowStyle(SizeType.Absolute, 64)) ' header height
        root.RowStyles.Add(New RowStyle(SizeType.Percent, 100)) ' content
        root.RowStyles.Add(New RowStyle(SizeType.Absolute, 56)) ' actions
        root.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 100))

        Dim header As New Label() With {
            .Text = "Per-Employee Payroll Entry",
            .Dock = DockStyle.Top,
            .Height = 64,
            .Font = New Font("Segoe UI", 13, FontStyle.Bold),
            .ForeColor = Color.White,
            .BackColor = Color.FromArgb(0, 120, 215),
            .Padding = New Padding(12, 10, 12, 10)
        }
        header.Dock = DockStyle.Fill
        root.Controls.Add(header, 0, 0)

        ' Content container sits under header and above actions; no overlap
        Dim content As New Panel() With {.Dock = DockStyle.Fill, .Padding = New Padding(16, 24, 16, 16), .AutoScroll = True}

        ' Card container at top; remove blue sub-header to maximize visible space
        Dim card As New Panel() With {.Dock = DockStyle.Top, .Height = 260, .Padding = New Padding(12), .BackColor = Color.White}
        ' Small spacer where the colored header used to be
        card.Controls.Add(New Panel() With {.Dock = DockStyle.Top, .Height = 8, .BackColor = Color.White})
        ' Card body layout: 2 columns (inputs left, summary right)
        Dim cardBody As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .ColumnCount = 2, .Padding = New Padding(6, 6, 6, 6)}
        cardBody.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 65))
        cardBody.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 35))

        Dim panel As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .Padding = New Padding(0, 4, 10, 4), .ColumnCount = 4}
        panel.ColumnStyles.Add(New ColumnStyle(SizeType.AutoSize))
        panel.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 50))
        panel.ColumnStyles.Add(New ColumnStyle(SizeType.AutoSize))
        panel.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 50))

        Dim r As Integer = 0
        panel.Controls.Add(New Label() With {.Text = "Employee", .AutoSize = True}, 0, r)
        cboUser.DropDownStyle = ComboBoxStyle.DropDownList
        cboUser.Width = 280
        panel.Controls.Add(cboUser, 1, r)
        panel.Controls.Add(New Label() With {.Text = "Work Date", .AutoSize = True}, 2, r)
        panel.Controls.Add(dtWorkDate, 3, r)
        r += 1
        panel.Controls.Add(New Label() With {.Text = "Branch", .AutoSize = True}, 0, r)
        panel.Controls.Add(cboBranch, 1, r)
        panel.Controls.Add(New Label() With {.Text = "Base Pay", .AutoSize = True}, 2, r)
        panel.Controls.Add(txtBase, 3, r)
        r += 1
        panel.Controls.Add(New Label() With {.Text = "Allowances", .AutoSize = True}, 0, r)
        panel.Controls.Add(txtAllow, 1, r)
        panel.Controls.Add(New Label() With {.Text = "Overtime", .AutoSize = True}, 2, r)
        panel.Controls.Add(txtOT, 3, r)
        r += 1
        panel.Controls.Add(New Label() With {.Text = "Bonuses", .AutoSize = True}, 0, r)
        panel.Controls.Add(txtBonus, 1, r)
        panel.Controls.Add(New Label() With {.Text = "Deductions", .AutoSize = True}, 2, r)
        panel.Controls.Add(txtDed, 3, r)
        r += 1
        panel.Controls.Add(New Label() With {.Text = "Sick Days", .AutoSize = True}, 0, r)
        panel.Controls.Add(txtSick, 1, r)
        panel.Controls.Add(New Label() With {.Text = "Leave Days", .AutoSize = True}, 2, r)
        panel.Controls.Add(txtLeave, 3, r)
        r += 1
        panel.Controls.Add(New Label() With {.Text = "Notes", .AutoSize = True}, 0, r)
        panel.Controls.Add(txtNotes, 1, r)
        panel.SetColumnSpan(txtNotes, 3)
        r += 1

        panel.Controls.Add(New Label() With {.Text = "Gross:", .AutoSize = True, .Font = New Font("Segoe UI", 9, FontStyle.Bold)}, 0, r)
        panel.Controls.Add(lblGross, 1, r)
        panel.Controls.Add(New Label() With {.Text = "Net:", .AutoSize = True, .Font = New Font("Segoe UI", 9, FontStyle.Bold)}, 2, r)
        panel.Controls.Add(lblNet, 3, r)
        r += 1

        ' Live summary grid
        If _summaryGrid Is Nothing Then
            _summaryGrid = New DataGridView() With {.Dock = DockStyle.Fill, .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False, .RowHeadersVisible = False, .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill}
            _summaryGrid.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Item", .Name = "Item"})
            _summaryGrid.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Amount", .Name = "Amount"})
        End If
        cardBody.Controls.Add(panel, 0, 0)
        cardBody.Controls.Add(_summaryGrid, 1, 0)
        card.Controls.Add(cardBody)

        content.Controls.Add(card)

        Dim actions As New FlowLayoutPanel() With {.Dock = DockStyle.Fill, .Height = 56, .Padding = New Padding(12)}
        btnSave.BackColor = Color.FromArgb(0, 120, 215)
        btnSave.ForeColor = Color.White
        AddHandler btnSave.Click, AddressOf OnSave
        actions.Controls.Add(btnSave)
        ' place content and actions in separate rows
        root.Controls.Add(content, 0, 1)
        root.SetColumnSpan(content, 1)
        root.Controls.Add(actions, 0, 2)
        Me.Controls.Add(root)

        AddHandler txtBase.TextChanged, AddressOf Recalc
        AddHandler txtAllow.TextChanged, AddressOf Recalc
        AddHandler txtOT.TextChanged, AddressOf Recalc
        AddHandler txtBonus.TextChanged, AddressOf Recalc
        AddHandler txtDed.TextChanged, AddressOf Recalc

        LoadLookups()
        Recalc(Nothing, EventArgs.Empty)
        ' Ensure the employee selector is immediately visible and focused
        AddHandler Me.Shown, Sub()
                                 Try
                                     cboUser.Focus()
                                 Catch
                                 End Try
                             End Sub
    End Sub

    Private Sub LoadLookups()
        ' Users
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT UserID, Username FROM Users WHERE IsActive = 1 ORDER BY Username", con)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                cboUser.DataSource = dt
                cboUser.DisplayMember = "Username"
                cboUser.ValueMember = "UserID"
            End Using
        End Using
        ' Branches
        Try
            Dim bs As New BranchService()
            Dim db As DataTable = bs.GetAllBranches()
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "ID"
            cboBranch.DataSource = db
        Catch
        End Try
        ' Default selections
        dtWorkDate.Value = Date.Today
        If cboBranch.Items.Count > 0 Then cboBranch.SelectedIndex = 0
    End Sub

    Private Sub Recalc(sender As Object, e As EventArgs)
        Dim basePay = ToDec(txtBase.Text)
        Dim allow = ToDec(txtAllow.Text)
        Dim ot = ToDec(txtOT.Text)
        Dim bonus = ToDec(txtBonus.Text)
        Dim ded = ToDec(txtDed.Text)
        Dim gross = basePay + allow + ot + bonus
        Dim net = gross - ded
        lblGross.Text = gross.ToString("N2")
        lblNet.Text = net.ToString("N2")
        ' Update summary grid live
        Try
            If _summaryGrid IsNot Nothing Then
                _summaryGrid.Rows.Clear()
                _summaryGrid.Rows.Add("Base Pay", basePay.ToString("N2"))
                _summaryGrid.Rows.Add("Allowances", allow.ToString("N2"))
                _summaryGrid.Rows.Add("Overtime", ot.ToString("N2"))
                _summaryGrid.Rows.Add("Bonuses", bonus.ToString("N2"))
                _summaryGrid.Rows.Add("Deductions", (ded * -1D).ToString("N2"))
                _summaryGrid.Rows.Add("Gross", gross.ToString("N2"))
                _summaryGrid.Rows.Add("Net", net.ToString("N2"))
            End If
        Catch
        End Try
    End Sub

    Private Function ToDec(s As String) As Decimal
        Dim v As Decimal = 0D
        Decimal.TryParse(If(s, "0"), v)
        Return v
    End Function

    Private Sub OnSave(sender As Object, e As EventArgs)
        If cboUser.SelectedValue Is Nothing Then
            MessageBox.Show("Select an employee (user)")
            Return
        End If
        If cboBranch.SelectedValue Is Nothing Then
            MessageBox.Show("Select a branch")
            Return
        End If

        Dim periodId = EnsureMonthlyPeriod(dtWorkDate.Value)
        If periodId = 0 Then
            MessageBox.Show("Could not ensure payroll period")
            Return
        End If

        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim sql As String = "INSERT INTO PayrollEntries(PeriodID, StaffID, BranchID, SalaryType, BasePay, Allowances, Overtime, Bonuses, Deductions, SickDays, LeaveDays, Notes, CreatedBy) " & _
                                "VALUES(@pid, @sid, @bid, @stype, @base, @allow, @ot, @bonus, @ded, @sick, @leave, @notes, @cb)"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@pid", periodId)
                cmd.Parameters.AddWithValue("@sid", CInt(cboUser.SelectedValue)) ' Using Users.UserID as salary owner
                cmd.Parameters.AddWithValue("@bid", CInt(cboBranch.SelectedValue))
                cmd.Parameters.AddWithValue("@stype", DBNull.Value)
                cmd.Parameters.AddWithValue("@base", ToDec(txtBase.Text))
                cmd.Parameters.AddWithValue("@allow", ToDec(txtAllow.Text))
                cmd.Parameters.AddWithValue("@ot", ToDec(txtOT.Text))
                cmd.Parameters.AddWithValue("@bonus", ToDec(txtBonus.Text))
                cmd.Parameters.AddWithValue("@ded", ToDec(txtDed.Text))
                cmd.Parameters.AddWithValue("@sick", ToDec(txtSick.Text))
                cmd.Parameters.AddWithValue("@leave", ToDec(txtLeave.Text))
                cmd.Parameters.AddWithValue("@notes", txtNotes.Text)
                cmd.Parameters.AddWithValue("@cb", AppSession.CurrentUserID)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        MessageBox.Show("Payroll entry saved.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Me.Close()
    End Sub

    Private Function EnsureMonthlyPeriod(d As Date) As Integer
        ' Ensures a YYYY-MM period exists and returns PeriodID
        Dim startD As New Date(d.Year, d.Month, 1)
        Dim endD As Date = startD.AddMonths(1).AddDays(-1)
        Dim name As String = $"{d:yyyy-MM}"
        Using con As New SqlConnection(connectionString)
            con.Open()
            ' Try find existing
            Using cmd As New SqlCommand("SELECT PeriodID FROM PayrollPeriods WHERE PeriodName=@n", con)
                cmd.Parameters.AddWithValue("@n", name)
                Dim o = cmd.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then
                    Return CInt(o)
                End If
            End Using
            ' Create new
            Using cmd As New SqlCommand("INSERT INTO PayrollPeriods(PeriodName, StartDate, EndDate) OUTPUT INSERTED.PeriodID VALUES(@n, @s, @e)", con)
                cmd.Parameters.AddWithValue("@n", name)
                cmd.Parameters.AddWithValue("@s", startD)
                cmd.Parameters.AddWithValue("@e", endD)
                Dim pid = Convert.ToInt32(cmd.ExecuteScalar())
                Return pid
            End Using
        End Using
    End Function
End Class
