Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Partial Public Class TimesheetEntryForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    Private ReadOnly _currentUserID As Integer

    Public Sub New()
        InitializeComponent()
        
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 1)
        _currentUserID = If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1)
        
        LoadEmployees()
        LoadTimesheets()
        
        AddHandler btnClockIn.Click, AddressOf BtnClockIn_Click
        AddHandler btnClockOut.Click, AddressOf BtnClockOut_Click
        AddHandler btnAddManual.Click, AddressOf BtnAddManual_Click
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        AddHandler dtpDate.ValueChanged, AddressOf DateFilter_Changed
        
        Theme.Apply(Me)
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Timesheet Entry - Clock In/Out"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 100,
            .BackColor = Color.FromArgb(0, 120, 215)
        }
        
        Dim lblTitle As New Label With {
            .Text = "TIMESHEET ENTRY",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblTitle)
        
        Dim lblSubtitle As New Label With {
            .Text = "Clock In/Out | Track Hours | Calculate Wages",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.White,
            .Location = New Point(20, 50),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblSubtitle)
        
        ' Control Panel
        Dim pnlControls As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        Dim lblEmployee As New Label With {.Text = "Employee:", .Location = New Point(20, 15), .AutoSize = True}
        Me.cboEmployee = New ComboBox With {
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Location = New Point(100, 12),
            .Width = 300
        }
        
        Dim lblDate As New Label With {.Text = "Date:", .Location = New Point(420, 15), .AutoSize = True}
        Me.dtpDate = New DateTimePicker With {
            .Format = DateTimePickerFormat.Short,
            .Location = New Point(470, 12),
            .Width = 150,
            .Value = DateTime.Today
        }
        
        Me.btnRefresh = New Button With {
            .Text = "Refresh",
            .Location = New Point(640, 10),
            .Size = New Size(100, 30)
        }
        
        ' Clock In/Out Buttons
        Me.btnClockIn = New Button With {
            .Text = "⏱ CLOCK IN",
            .Location = New Point(20, 60),
            .Size = New Size(150, 45),
            .BackColor = Color.FromArgb(0, 150, 0),
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold)
        }
        
        Me.btnClockOut = New Button With {
            .Text = "⏱ CLOCK OUT",
            .Location = New Point(180, 60),
            .Size = New Size(150, 45),
            .BackColor = Color.FromArgb(200, 0, 0),
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold)
        }
        
        Me.btnAddManual = New Button With {
            .Text = "✏ Add Manual Entry",
            .Location = New Point(340, 60),
            .Size = New Size(180, 45),
            .BackColor = Color.FromArgb(100, 100, 100),
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 11)
        }
        
        ' Current Status Label
        Me.lblCurrentStatus = New Label With {
            .Text = "Status: Not Clocked In",
            .Location = New Point(540, 70),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.Gray,
            .AutoSize = True
        }
        
        pnlControls.Controls.AddRange({lblEmployee, cboEmployee, lblDate, dtpDate, btnRefresh, btnClockIn, btnClockOut, btnAddManual, lblCurrentStatus})
        
        ' Summary Panel
        Dim pnlSummary As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 60,
            .Padding = New Padding(20, 10, 20, 10),
            .BackColor = Color.FromArgb(240, 240, 240)
        }
        
        Me.lblTotalHours = New Label With {
            .Text = "Total Hours: 0.00",
            .Location = New Point(20, 15),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .AutoSize = True
        }
        
        Me.lblOvertimeHours = New Label With {
            .Text = "Overtime: 0.00",
            .Location = New Point(200, 15),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(200, 100, 0),
            .AutoSize = True
        }
        
        Me.lblEstimatedWages = New Label With {
            .Text = "Estimated Wages: R 0.00",
            .Location = New Point(380, 15),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(0, 120, 0),
            .AutoSize = True
        }
        
        pnlSummary.Controls.AddRange({lblTotalHours, lblOvertimeHours, lblEstimatedWages})
        
        ' DataGridView
        Me.dgvTimesheets = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White
        }
        
        Me.Controls.Add(dgvTimesheets)
        Me.Controls.Add(pnlSummary)
        Me.Controls.Add(pnlControls)
        Me.Controls.Add(pnlHeader)
    End Sub

    Private cboEmployee As ComboBox
    Private dtpDate As DateTimePicker
    Private btnRefresh As Button
    Private btnClockIn As Button
    Private btnClockOut As Button
    Private btnAddManual As Button
    Private lblCurrentStatus As Label
    Private dgvTimesheets As DataGridView
    Private lblTotalHours As Label
    Private lblOvertimeHours As Label
    Private lblEstimatedWages As Label

    Private Sub LoadEmployees()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, HourlyRate 
                           FROM Employees 
                           WHERE IsActive = 1 AND PaymentType = 'Hourly'
                           ORDER BY FirstName, LastName"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    cboEmployee.DataSource = dt
                    cboEmployee.DisplayMember = "FullName"
                    cboEmployee.ValueMember = "EmployeeID"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading employees: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadTimesheets()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT 
                    t.TimesheetID,
                    e.FirstName + ' ' + e.LastName AS Employee,
                    t.WorkDate,
                    CONVERT(VARCHAR(5), t.ClockIn, 108) AS ClockIn,
                    CONVERT(VARCHAR(5), t.ClockOut, 108) AS ClockOut,
                    t.HoursWorked,
                    t.OvertimeHours,
                    e.HourlyRate,
                    (t.HoursWorked * e.HourlyRate) + (t.OvertimeHours * e.HourlyRate * 1.5) AS EstimatedWages,
                    t.Status
                FROM Timesheets t
                INNER JOIN Employees e ON t.EmployeeID = e.EmployeeID
                WHERE t.WorkDate = @date
                AND (@empID IS NULL OR t.EmployeeID = @empID)
                ORDER BY t.ClockIn DESC"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim empID As Object = If(cboEmployee.SelectedValue Is Nothing, DBNull.Value, cboEmployee.SelectedValue)
                    da.SelectCommand.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@empID", empID)
                    
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvTimesheets.DataSource = dt
                    
                    ' Format columns
                    If dgvTimesheets.Columns.Contains("HoursWorked") Then
                        dgvTimesheets.Columns("HoursWorked").DefaultCellStyle.Format = "N2"
                    End If
                    If dgvTimesheets.Columns.Contains("OvertimeHours") Then
                        dgvTimesheets.Columns("OvertimeHours").DefaultCellStyle.Format = "N2"
                    End If
                    If dgvTimesheets.Columns.Contains("HourlyRate") Then
                        dgvTimesheets.Columns("HourlyRate").DefaultCellStyle.Format = "C2"
                    End If
                    If dgvTimesheets.Columns.Contains("EstimatedWages") Then
                        dgvTimesheets.Columns("EstimatedWages").DefaultCellStyle.Format = "C2"
                    End If
                    
                    UpdateSummary(dt)
                    CheckCurrentStatus()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading timesheets: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Try
            Dim totalHours As Decimal = 0
            Dim overtimeHours As Decimal = 0
            Dim estimatedWages As Decimal = 0
            
            For Each row As DataRow In dt.Rows
                totalHours += If(IsDBNull(row("HoursWorked")), 0, CDec(row("HoursWorked")))
                overtimeHours += If(IsDBNull(row("OvertimeHours")), 0, CDec(row("OvertimeHours")))
                estimatedWages += If(IsDBNull(row("EstimatedWages")), 0, CDec(row("EstimatedWages")))
            Next
            
            lblTotalHours.Text = $"Total Hours: {totalHours:N2}"
            lblOvertimeHours.Text = $"Overtime: {overtimeHours:N2}"
            lblEstimatedWages.Text = $"Estimated Wages: {estimatedWages:C2}"
        Catch ex As Exception
            ' Silent fail on summary
        End Try
    End Sub

    Private Sub CheckCurrentStatus()
        Try
            If cboEmployee.SelectedValue Is Nothing Then Return
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT TOP 1 ClockIn, ClockOut FROM Timesheets 
                           WHERE EmployeeID = @empID AND WorkDate = @date 
                           ORDER BY ClockIn DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@empID", cboEmployee.SelectedValue)
                    cmd.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                    
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            If IsDBNull(reader("ClockOut")) Then
                                lblCurrentStatus.Text = $"Status: CLOCKED IN at {CDate(reader("ClockIn")):HH:mm}"
                                lblCurrentStatus.ForeColor = Color.FromArgb(0, 150, 0)
                                btnClockIn.Enabled = False
                                btnClockOut.Enabled = True
                            Else
                                lblCurrentStatus.Text = "Status: Clocked Out"
                                lblCurrentStatus.ForeColor = Color.Gray
                                btnClockIn.Enabled = True
                                btnClockOut.Enabled = False
                            End If
                        Else
                            lblCurrentStatus.Text = "Status: Not Clocked In"
                            lblCurrentStatus.ForeColor = Color.Gray
                            btnClockIn.Enabled = True
                            btnClockOut.Enabled = False
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ' Silent fail
        End Try
    End Sub

    Private Sub BtnClockIn_Click(sender As Object, e As EventArgs)
        Try
            If cboEmployee.SelectedValue Is Nothing Then
                MessageBox.Show("Please select an employee", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "INSERT INTO Timesheets (EmployeeID, WorkDate, ClockIn, Status, CreatedDate)
                           VALUES (@empID, @date, SYSDATETIME(), 'Pending', SYSUTCDATETIME())"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@empID", cboEmployee.SelectedValue)
                    cmd.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show("Clocked In successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadTimesheets()
            
        Catch ex As Exception
            MessageBox.Show("Error clocking in: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnClockOut_Click(sender As Object, e As EventArgs)
        Try
            If cboEmployee.SelectedValue Is Nothing Then
                MessageBox.Show("Please select an employee", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim hoursWorked As Decimal = 0
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Get the open timesheet
                Dim sql = "SELECT TOP 1 TimesheetID, ClockIn FROM Timesheets 
                           WHERE EmployeeID = @empID AND WorkDate = @date AND ClockOut IS NULL
                           ORDER BY ClockIn DESC"
                
                Dim timesheetID As Integer = 0
                Dim clockIn As DateTime
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@empID", cboEmployee.SelectedValue)
                    cmd.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                    
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            timesheetID = CInt(reader("TimesheetID"))
                            clockIn = CDate(reader("ClockIn"))
                        End If
                    End Using
                End Using
                
                If timesheetID = 0 Then
                    MessageBox.Show("No open clock-in found", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                ' Calculate hours
                Dim clockOut = DateTime.Now
                hoursWorked = CDec((clockOut - clockIn).TotalHours)
                Dim overtimeHours As Decimal = If(hoursWorked > 8, hoursWorked - 8, 0)
                Dim regularHours = hoursWorked - overtimeHours
                
                ' Update timesheet
                sql = "UPDATE Timesheets SET ClockOut = @clockOut, HoursWorked = @hours, OvertimeHours = @overtime
                       WHERE TimesheetID = @id"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@clockOut", clockOut)
                    cmd.Parameters.AddWithValue("@hours", regularHours)
                    cmd.Parameters.AddWithValue("@overtime", overtimeHours)
                    cmd.Parameters.AddWithValue("@id", timesheetID)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show($"Clocked Out successfully!{vbCrLf}Hours Worked: {hoursWorked:N2}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadTimesheets()
            
        Catch ex As Exception
            MessageBox.Show("Error clocking out: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnAddManual_Click(sender As Object, e As EventArgs)
        Using frm As New ManualTimesheetEntryForm(cboEmployee.SelectedValue, dtpDate.Value.Date)
            If frm.ShowDialog() = DialogResult.OK Then
                LoadTimesheets()
            End If
        End Using
    End Sub

    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadTimesheets()
    End Sub

    Private Sub DateFilter_Changed(sender As Object, e As EventArgs)
        LoadTimesheets()
    End Sub
End Class

' =============================================
' Manual Timesheet Entry Dialog
' =============================================
Public Class ManualTimesheetEntryForm
    Inherits Form
    
    Private ReadOnly _employeeID As Object
    Private ReadOnly _workDate As Date
    Private ReadOnly _connString As String
    
    Private dtpClockIn As DateTimePicker
    Private dtpClockOut As DateTimePicker
    Private txtHours As TextBox
    Private txtOvertime As TextBox
    Private txtNotes As TextBox
    Private btnSave As Button
    Private btnCancel As Button
    
    Public Sub New(employeeID As Object, workDate As Date)
        _employeeID = employeeID
        _workDate = workDate
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        AddHandler btnCancel.Click, AddressOf BtnCancel_Click
        
        Theme.Apply(Me)
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Manual Timesheet Entry"
        Me.Size = New Size(450, 400)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        
        Dim y = 20
        
        ' Clock In
        Dim lblIn As New Label With {.Text = "Clock In Time:", .Location = New Point(20, y), .AutoSize = True}
        dtpClockIn = New DateTimePicker With {
            .Format = DateTimePickerFormat.Time,
            .ShowUpDown = True,
            .Location = New Point(150, y - 3),
            .Width = 250
        }
        Me.Controls.AddRange({lblIn, dtpClockIn})
        y += 35
        
        ' Clock Out
        Dim lblOut As New Label With {.Text = "Clock Out Time:", .Location = New Point(20, y), .AutoSize = True}
        dtpClockOut = New DateTimePicker With {
            .Format = DateTimePickerFormat.Time,
            .ShowUpDown = True,
            .Location = New Point(150, y - 3),
            .Width = 250
        }
        Me.Controls.AddRange({lblOut, dtpClockOut})
        y += 35
        
        ' Hours
        Dim lblHours As New Label With {.Text = "Regular Hours:", .Location = New Point(20, y), .AutoSize = True}
        txtHours = New TextBox With {
            .Location = New Point(150, y - 3),
            .Width = 250,
            .TextAlign = HorizontalAlignment.Right,
            .Text = "8.00"
        }
        Me.Controls.AddRange({lblHours, txtHours})
        y += 35
        
        ' Overtime
        Dim lblOT As New Label With {.Text = "Overtime Hours:", .Location = New Point(20, y), .AutoSize = True}
        txtOvertime = New TextBox With {
            .Location = New Point(150, y - 3),
            .Width = 250,
            .TextAlign = HorizontalAlignment.Right,
            .Text = "0.00"
        }
        Me.Controls.AddRange({lblOT, txtOvertime})
        y += 35
        
        ' Notes
        Dim lblNotes As New Label With {.Text = "Notes:", .Location = New Point(20, y), .AutoSize = True}
        txtNotes = New TextBox With {
            .Location = New Point(150, y - 3),
            .Width = 250,
            .Height = 60,
            .Multiline = True
        }
        Me.Controls.AddRange({lblNotes, txtNotes})
        y += 80
        
        ' Buttons
        btnSave = New Button With {
            .Text = "Save",
            .Location = New Point(200, y),
            .Size = New Size(100, 35)
        }
        
        btnCancel = New Button With {
            .Text = "Cancel",
            .Location = New Point(310, y),
            .Size = New Size(90, 35)
        }
        
        Me.Controls.AddRange({btnSave, btnCancel})
    End Sub
    
    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        Try
            Dim hours As Decimal
            Dim overtime As Decimal
            
            If Not Decimal.TryParse(txtHours.Text, hours) OrElse hours < 0 Then
                MessageBox.Show("Please enter valid hours", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If Not Decimal.TryParse(txtOvertime.Text, overtime) OrElse overtime < 0 Then
                MessageBox.Show("Please enter valid overtime hours", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim clockIn = New DateTime(_workDate.Year, _workDate.Month, _workDate.Day, dtpClockIn.Value.Hour, dtpClockIn.Value.Minute, 0)
                Dim clockOut = New DateTime(_workDate.Year, _workDate.Month, _workDate.Day, dtpClockOut.Value.Hour, dtpClockOut.Value.Minute, 0)
                
                Dim sql = "INSERT INTO Timesheets (EmployeeID, WorkDate, ClockIn, ClockOut, HoursWorked, OvertimeHours, Status, CreatedDate)
                           VALUES (@empID, @date, @in, @out, @hours, @overtime, 'Pending', SYSUTCDATETIME())"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@empID", _employeeID)
                    cmd.Parameters.AddWithValue("@date", _workDate)
                    cmd.Parameters.AddWithValue("@in", clockIn)
                    cmd.Parameters.AddWithValue("@out", clockOut)
                    cmd.Parameters.AddWithValue("@hours", hours)
                    cmd.Parameters.AddWithValue("@overtime", overtime)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show("Manual timesheet entry saved!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.DialogResult = DialogResult.OK
            Me.Close()
            
        Catch ex As Exception
            MessageBox.Show("Error saving timesheet: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
