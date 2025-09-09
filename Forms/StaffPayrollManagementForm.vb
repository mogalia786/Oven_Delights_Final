Imports System
Imports System.Data
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient

Public Class StaffPayrollManagementForm
    Inherits Form

    Private ReadOnly grd As New DataGridView() With {.Dock = DockStyle.Fill, .AllowUserToAddRows = False, .ReadOnly = True, .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill, .RowHeadersVisible = False}
    Private ReadOnly btnAdd As New Button() With {.Text = "Add"}
    Private ReadOnly btnEdit As New Button() With {.Text = "Edit"}
    Private ReadOnly btnDelete As New Button() With {.Text = "Delete"}
    Private ReadOnly btnClose As New Button() With {.Text = "Close"}

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Sub New()
        Me.Text = "Staff Payroll Management"
        Me.Width = 1000
        Me.Height = 650
        Me.BackColor = Color.White
        Me.FormBorderStyle = FormBorderStyle.FixedSingle

        ' Buttons style
        btnAdd.BackColor = Color.FromArgb(0, 120, 215)
        btnAdd.ForeColor = Color.White
        btnAdd.FlatStyle = FlatStyle.Flat
        btnAdd.FlatAppearance.BorderSize = 0

        btnEdit.BackColor = Color.FromArgb(40, 167, 69)
        btnEdit.ForeColor = Color.White
        btnEdit.FlatStyle = FlatStyle.Flat
        btnEdit.FlatAppearance.BorderSize = 0

        btnDelete.BackColor = Color.FromArgb(220, 53, 69)
        btnDelete.ForeColor = Color.White
        btnDelete.FlatStyle = FlatStyle.Flat
        btnDelete.FlatAppearance.BorderSize = 0

        btnClose.BackColor = Color.FromArgb(108, 117, 125)
        btnClose.ForeColor = Color.White
        btnClose.FlatStyle = FlatStyle.Flat
        btnClose.FlatAppearance.BorderSize = 0

        Dim header As New Label() With {
            .Text = "Staff Payroll",
            .Dock = DockStyle.Top,
            .Height = 48,
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = Color.White,
            .BackColor = Color.FromArgb(0, 120, 215),
            .Padding = New Padding(12, 10, 12, 10)
        }
        Controls.Add(header)
        ' Spacer so grid never hides under blue banner
        Controls.Add(New Panel() With {.Dock = DockStyle.Top, .Height = 56})

        Dim topPanel As New FlowLayoutPanel() With {.Dock = DockStyle.Top, .Height = 52, .Padding = New Padding(8)}
        topPanel.Controls.AddRange(New Control() {btnAdd, btnEdit, btnDelete, btnClose})
        Controls.Add(grd)
        Controls.Add(topPanel)
        ' Keep banner on top of z-order
        header.BringToFront()

        AddHandler btnClose.Click, Sub() Me.Close()
        AddHandler btnAdd.Click, AddressOf OnAdd
        AddHandler btnEdit.Click, AddressOf OnEdit
        AddHandler btnDelete.Click, AddressOf OnDelete

        Try
            LoadStaff()
        Catch ex As Exception
            MessageBox.Show("Staff payroll load error: " & ex.Message & Environment.NewLine & _
                            "Ensure the Staff table exists with columns: StaffID, EmployeeNo, FullName, Role, SalaryType, BasePay, HolidayPct, BonusPct, SickDays, LeaveDays.", _
                            "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub LoadStaff()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim sql As String = "SELECT StaffID, EmployeeNo, FullName, Role, SalaryType, BasePay, HolidayPct, BonusPct, SickDays, LeaveDays FROM Staff ORDER BY EmployeeNo"
            Using cmd As New SqlCommand(sql, con)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                grd.DataSource = dt
            End Using
        End Using
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Using dlg As New StaffPayrollEditDialog()
            If dlg.ShowDialog(Me) = DialogResult.OK AndAlso dlg.Saved Then
                LoadStaff()
            End If
        End Using
    End Sub

    Private Sub OnEdit(sender As Object, e As EventArgs)
        If grd.CurrentRow Is Nothing Then Return
        Dim drv As DataRowView = TryCast(grd.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return
        Dim id As Integer = CInt(drv.Row("StaffID"))
        Using dlg As New StaffPayrollEditDialog(id)
            If dlg.ShowDialog(Me) = DialogResult.OK AndAlso dlg.Saved Then
                LoadStaff()
            End If
        End Using
    End Sub

    Private Sub OnDelete(sender As Object, e As EventArgs)
        Try
            If grd.CurrentRow Is Nothing Then Return
            Dim drv As DataRowView = TryCast(grd.CurrentRow.DataBoundItem, DataRowView)
            If drv Is Nothing Then Return
            Dim id As Integer = CInt(drv.Row("StaffID"))
            Dim name As String = Convert.ToString(drv.Row("FullName"))
            If MessageBox.Show($"Delete {name}?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) <> DialogResult.Yes Then Return
            Using con As New SqlConnection(connectionString)
                con.Open()
                Using cmd As New SqlCommand("DELETE FROM Staff WHERE StaffID=@id", con)
                    cmd.Parameters.AddWithValue("@id", id)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadStaff()
        Catch ex As Exception
            MessageBox.Show("Delete error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class

Public Class StaffPayrollEditDialog
    Inherits Form

    Public Property Saved As Boolean
    Private ReadOnly txtEmpNo As New TextBox()
    Private ReadOnly txtName As New TextBox()
    Private ReadOnly cboRole As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly cboSalaryType As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly numBase As New NumericUpDown() With {.DecimalPlaces = 2, .Maximum = Decimal.MaxValue, .ThousandsSeparator = True}
    Private ReadOnly numHoliday As New NumericUpDown() With {.DecimalPlaces = 2, .Maximum = 100, .ThousandsSeparator = True}
    Private ReadOnly numBonus As New NumericUpDown() With {.DecimalPlaces = 2, .Maximum = 100, .ThousandsSeparator = True}
    Private ReadOnly numSick As New NumericUpDown() With {.DecimalPlaces = 0, .Maximum = 365}
    Private ReadOnly numLeave As New NumericUpDown() With {.DecimalPlaces = 0, .Maximum = 365}
    Private ReadOnly btnSave As New Button() With {.Text = "Save"}
    Private ReadOnly btnCancel As New Button() With {.Text = "Cancel"}

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private ReadOnly editId As Integer

    Public Sub New(Optional staffId As Integer = 0)
        Me.editId = staffId
        Me.Text = If(staffId = 0, "Add Staff Payroll", "Edit Staff Payroll")
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.StartPosition = FormStartPosition.CenterParent
        Me.Size = New Size(560, 420)
        Me.BackColor = Color.FromArgb(247, 249, 252)

        cboSalaryType.Items.AddRange(New Object() {"Monthly", "Weekly", "Hourly"})

        btnSave.BackColor = Color.FromArgb(0, 120, 215)
        btnSave.ForeColor = Color.White
        btnSave.FlatStyle = FlatStyle.Flat
        btnSave.FlatAppearance.BorderSize = 0
        btnCancel.BackColor = Color.FromArgb(108, 117, 125)
        btnCancel.ForeColor = Color.White
        btnCancel.FlatStyle = FlatStyle.Flat
        btnCancel.FlatAppearance.BorderSize = 0

        Dim layout As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .ColumnCount = 2, .RowCount = 8, .Padding = New Padding(12)}
        layout.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 40))
        layout.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 60))
        For i = 0 To 6
            layout.RowStyles.Add(New RowStyle(SizeType.Absolute, 42))
        Next
        layout.RowStyles.Add(New RowStyle(SizeType.AutoSize))

        layout.Controls.Add(New Label() With {.Text = "Employee #:", .AutoSize = True}, 0, 0)
        layout.Controls.Add(txtEmpNo, 1, 0)
        layout.Controls.Add(New Label() With {.Text = "Full Name:", .AutoSize = True}, 0, 1)
        layout.Controls.Add(txtName, 1, 1)
        layout.Controls.Add(New Label() With {.Text = "Role:", .AutoSize = True}, 0, 2)
        layout.Controls.Add(cboRole, 1, 2)
        layout.Controls.Add(New Label() With {.Text = "Salary Type:", .AutoSize = True}, 0, 3)
        layout.Controls.Add(cboSalaryType, 1, 3)
        layout.Controls.Add(New Label() With {.Text = "Base Pay:", .AutoSize = True}, 0, 4)
        layout.Controls.Add(numBase, 1, 4)
        layout.Controls.Add(New Label() With {.Text = "Holiday %:", .AutoSize = True}, 0, 5)
        layout.Controls.Add(numHoliday, 1, 5)
        layout.Controls.Add(New Label() With {.Text = "Bonus %:", .AutoSize = True}, 0, 6)
        layout.Controls.Add(numBonus, 1, 6)

        Dim row7 As New FlowLayoutPanel() With {.Dock = DockStyle.Fill}
        row7.Controls.Add(New Label() With {.Text = "Sick Days:", .AutoSize = True, .Margin = New Padding(0, 8, 8, 0)})
        row7.Controls.Add(numSick)
        row7.Controls.Add(New Label() With {.Text = "Leave Days:", .AutoSize = True, .Margin = New Padding(16, 8, 8, 0)})
        row7.Controls.Add(numLeave)
        layout.Controls.Add(row7, 1, 7)

        Dim btns As New FlowLayoutPanel() With {.Dock = DockStyle.Bottom, .FlowDirection = FlowDirection.RightToLeft}
        btns.Controls.Add(btnCancel)
        btns.Controls.Add(btnSave)
        layout.Controls.Add(btns, 0, 8)
        layout.SetColumnSpan(btns, 2)

        Controls.Add(layout)

        AddHandler btnCancel.Click, Sub() Me.Close()
        AddHandler btnSave.Click, AddressOf OnSave

        LoadRoles()
        If editId > 0 Then LoadExisting()
    End Sub

    Private Sub LoadRoles()
        ' Roles are textual here (e.g., Cashier, Administrator, Stockroom Manager)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT DISTINCT Role FROM Staff WHERE Role IS NOT NULL ORDER BY Role", con)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                cboRole.DataSource = dt
                cboRole.DisplayMember = "Role"
                cboRole.ValueMember = "Role"
            End Using
        End Using
        ' Provide common defaults if empty
        If cboRole.Items.Count = 0 Then
            cboRole.Items.AddRange(New Object() {"Cashier", "Administrator", "Stockroom Manager", "Manufacturing Manager", "Retail Manager"})
        End If
    End Sub

    Private Sub LoadExisting()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT EmployeeNo, FullName, Role, SalaryType, BasePay, HolidayPct, BonusPct, SickDays, LeaveDays FROM Staff WHERE StaffID=@id", con)
                cmd.Parameters.AddWithValue("@id", editId)
                Using r = cmd.ExecuteReader()
                    If r.Read() Then
                        txtEmpNo.Text = If(r("EmployeeNo") Is DBNull.Value, "", r("EmployeeNo").ToString())
                        txtName.Text = If(r("FullName") Is DBNull.Value, "", r("FullName").ToString())
                        Dim roleVal = If(r("Role") Is DBNull.Value, Nothing, r("Role").ToString())
                        If roleVal IsNot Nothing Then cboRole.SelectedValue = roleVal
                        Dim sType = If(r("SalaryType") Is DBNull.Value, "", r("SalaryType").ToString())
                        If Not String.IsNullOrWhiteSpace(sType) Then cboSalaryType.SelectedItem = sType
                        numBase.Value = If(IsDBNull(r("BasePay")), 0D, Convert.ToDecimal(r("BasePay")))
                        numHoliday.Value = If(IsDBNull(r("HolidayPct")), 0D, Convert.ToDecimal(r("HolidayPct")))
                        numBonus.Value = If(IsDBNull(r("BonusPct")), 0D, Convert.ToDecimal(r("BonusPct")))
                        numSick.Value = If(IsDBNull(r("SickDays")), 0, Convert.ToInt32(r("SickDays")))
                        numLeave.Value = If(IsDBNull(r("LeaveDays")), 0, Convert.ToInt32(r("LeaveDays")))
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            Dim empNo = txtEmpNo.Text.Trim()
            Dim name = txtName.Text.Trim()
            Dim role = If(cboRole.SelectedItem Is Nothing, Nothing, cboRole.Text.Trim())
            Dim sType = If(cboSalaryType.SelectedItem Is Nothing, Nothing, cboSalaryType.SelectedItem.ToString())

            If String.IsNullOrWhiteSpace(empNo) OrElse String.IsNullOrWhiteSpace(name) Then
                MessageBox.Show("Employee # and Full Name are required.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Using con As New SqlConnection(connectionString)
                con.Open()
                If editId = 0 Then
                    Using cmd As New SqlCommand("INSERT INTO Staff (EmployeeNo, FullName, Role, SalaryType, BasePay, HolidayPct, BonusPct, SickDays, LeaveDays) VALUES (@eno,@name,@role,@stype,@base,@hol,@bon,@sick,@leave)", con)
                        cmd.Parameters.AddWithValue("@eno", empNo)
                        cmd.Parameters.AddWithValue("@name", name)
                        cmd.Parameters.AddWithValue("@role", If(String.IsNullOrWhiteSpace(role), DBNull.Value, CObj(role)))
                        cmd.Parameters.AddWithValue("@stype", If(String.IsNullOrWhiteSpace(sType), DBNull.Value, CObj(sType)))
                        cmd.Parameters.AddWithValue("@base", Math.Round(numBase.Value, 2))
                        cmd.Parameters.AddWithValue("@hol", Math.Round(numHoliday.Value, 2))
                        cmd.Parameters.AddWithValue("@bon", Math.Round(numBonus.Value, 2))
                        cmd.Parameters.AddWithValue("@sick", CInt(numSick.Value))
                        cmd.Parameters.AddWithValue("@leave", CInt(numLeave.Value))
                        cmd.ExecuteNonQuery()
                    End Using
                Else
                    Using cmd As New SqlCommand("UPDATE Staff SET EmployeeNo=@eno, FullName=@name, Role=@role, SalaryType=@stype, BasePay=@base, HolidayPct=@hol, BonusPct=@bon, SickDays=@sick, LeaveDays=@leave WHERE StaffID=@id", con)
                        cmd.Parameters.AddWithValue("@id", editId)
                        cmd.Parameters.AddWithValue("@eno", empNo)
                        cmd.Parameters.AddWithValue("@name", name)
                        cmd.Parameters.AddWithValue("@role", If(String.IsNullOrWhiteSpace(role), DBNull.Value, CObj(role)))
                        cmd.Parameters.AddWithValue("@stype", If(String.IsNullOrWhiteSpace(sType), DBNull.Value, CObj(sType)))
                        cmd.Parameters.AddWithValue("@base", Math.Round(numBase.Value, 2))
                        cmd.Parameters.AddWithValue("@hol", Math.Round(numHoliday.Value, 2))
                        cmd.Parameters.AddWithValue("@bon", Math.Round(numBonus.Value, 2))
                        cmd.Parameters.AddWithValue("@sick", CInt(numSick.Value))
                        cmd.Parameters.AddWithValue("@leave", CInt(numLeave.Value))
                        cmd.ExecuteNonQuery()
                    End Using
                End If
            End Using

            Saved = True
            Me.DialogResult = DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show("Save error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
