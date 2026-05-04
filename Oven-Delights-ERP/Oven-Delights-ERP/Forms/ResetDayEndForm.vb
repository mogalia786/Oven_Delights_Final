Imports System.Data.SqlClient
Imports System.Configuration

Public Class ResetDayEndForm
    Private _connectionString As String
    Private _adminUserID As Integer
    Private _adminUserName As String
    
    Public Sub New(adminUserID As Integer, adminUserName As String)
        InitializeComponent()
        
        _adminUserID = adminUserID
        _adminUserName = adminUserName
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub
    
    Private Sub ResetDayEndForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Reset Day End - Administrator Only"
        Me.Size = New Size(900, 600)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        SetupUI()
        LoadIncompleteDayEnds()
    End Sub
    
    Private Sub SetupUI()
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#E74C3C")
        }
        
        Dim lblTitle As New Label With {
            .Text = "⚠️ RESET DAY END - ADMINISTRATOR FUNCTION",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        
        Dim lblSubtitle As New Label With {
            .Text = $"Administrator: {_adminUserName}",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 50)
        }
        
        pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})
        
        ' Instructions Panel
        Dim pnlInstructions As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = ColorTranslator.FromHtml("#FFF3CD"),
            .Padding = New Padding(20)
        }
        
        Dim lblInstructions As New Label With {
            .Text = "⚠️ WARNING: This function should only be used after investigating incomplete day-ends." & vbCrLf & vbCrLf &
                   "Before resetting:" & vbCrLf &
                   "1. Verify no fraudulent activity occurred" & vbCrLf &
                   "2. Confirm all cash has been secured" & vbCrLf &
                   "3. Document the reason for incomplete day-end" & vbCrLf & vbCrLf &
                   "Resetting will allow all tills to log in for the current day.",
            .Font = New Font("Segoe UI", 9),
            .ForeColor = ColorTranslator.FromHtml("#856404"),
            .AutoSize = False,
            .Dock = DockStyle.Fill
        }
        
        pnlInstructions.Controls.Add(lblInstructions)
        
        ' DataGridView for incomplete day-ends
        Dim dgvIncompleteTills As New DataGridView With {
            .Name = "dgvIncompleteTills",
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 10)
        }
        
        dgvIncompleteTills.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#2C3E50")
        dgvIncompleteTills.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvIncompleteTills.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvIncompleteTills.ColumnHeadersHeight = 40
        dgvIncompleteTills.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#ECF0F1")
        
        ' Middle Panel for DataGridView
        Dim pnlMiddle As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20)
        }
        pnlMiddle.Controls.Add(dgvIncompleteTills)
        
        ' Bottom Panel for buttons
        Dim pnlBottom As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 100,
            .BackColor = Color.White,
            .Padding = New Padding(20)
        }
        
        Dim btnRefresh As New Button With {
            .Text = "🔄 Refresh",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 50),
            .Location = New Point(20, 25),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        
        Dim btnReset As New Button With {
            .Text = "⚠️ RESET DAY END",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(200, 50),
            .Location = New Point(190, 25),
            .BackColor = ColorTranslator.FromHtml("#E74C3C"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnReset.FlatAppearance.BorderSize = 0
        AddHandler btnReset.Click, AddressOf BtnReset_Click
        
        Dim btnClose As New Button With {
            .Text = "✖ Close",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 50),
            .Location = New Point(Me.Width - 190, 25),
            .BackColor = ColorTranslator.FromHtml("#95A5A6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand,
            .Anchor = AnchorStyles.Top Or AnchorStyles.Right
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub() Me.Close()
        
        pnlBottom.Controls.AddRange({btnRefresh, btnReset, btnClose})
        
        ' Add all panels to form
        Me.Controls.Add(pnlMiddle)
        Me.Controls.Add(pnlBottom)
        Me.Controls.Add(pnlInstructions)
        Me.Controls.Add(pnlHeader)
    End Sub
    
    Private Sub LoadIncompleteDayEnds()
        Try
            Dim dgv = DirectCast(Me.Controls.Find("dgvIncompleteTills", True)(0), DataGridView)
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Get yesterday's date
                Dim yesterday = DateTime.Today.AddDays(-1)
                
                Dim sql = "
                    SELECT 
                        tp.TillPointID,
                        'Till ' + CAST(tp.TillNumber AS NVARCHAR(10)) AS TillName,
                        b.BranchName,
                        tde.BusinessDate,
                        tde.CashierName,
                        tde.CreatedAt,
                        DATEDIFF(HOUR, tde.CreatedAt, GETDATE()) AS HoursOverdue
                    FROM TillDayEnd tde
                    INNER JOIN TillPoints tp ON tde.TillPointID = tp.TillPointID
                    INNER JOIN Branches b ON tp.BranchID = b.BranchID
                    WHERE tde.BusinessDate = @Yesterday
                    AND tde.IsDayEnd = 0
                    ORDER BY tp.TillNumber"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Yesterday", yesterday)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        If dt.Rows.Count > 0 Then
                            dgv.DataSource = dt
                            dgv.Columns("TillPointID").Visible = False
                            dgv.Columns("TillName").HeaderText = "Till Name"
                            dgv.Columns("BranchName").HeaderText = "Branch"
                            dgv.Columns("BusinessDate").HeaderText = "Business Date"
                            dgv.Columns("CashierName").HeaderText = "Cashier"
                            dgv.Columns("CreatedAt").HeaderText = "Started At"
                            dgv.Columns("HoursOverdue").HeaderText = "Hours Overdue"
                            
                            ' Highlight overdue hours in red
                            For Each row As DataGridViewRow In dgv.Rows
                                If CInt(row.Cells("HoursOverdue").Value) > 12 Then
                                    row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FFCCCC")
                                End If
                            Next
                        Else
                            ' No incomplete day-ends - create proper empty table
                            Dim emptyDt As New DataTable()
                            emptyDt.Columns.Add("Message", GetType(String))
                            emptyDt.Rows.Add("✅ All tills completed day-end for previous day. No action required.")
                            dgv.DataSource = emptyDt
                        End If
                    End Using
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Failed to load incomplete day-ends: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadIncompleteDayEnds()
    End Sub
    
    Private Sub BtnReset_Click(sender As Object, e As EventArgs)
        Try
            Dim dgv = DirectCast(Me.Controls.Find("dgvIncompleteTills", True)(0), DataGridView)
            
            If dgv.DataSource Is Nothing OrElse DirectCast(dgv.DataSource, DataTable).Rows.Count = 0 Then
                MessageBox.Show("No incomplete day-ends to reset.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            ' Require reason for reset
            Dim reason = InputBox("⚠️ ADMINISTRATOR AUTHORIZATION REQUIRED" & vbCrLf & vbCrLf &
                                 "Enter reason for resetting day-end:" & vbCrLf &
                                 "(This will be logged in the audit trail)", "Reset Reason Required", "")
            
            If String.IsNullOrWhiteSpace(reason) Then
                MessageBox.Show("Reset cancelled - reason is required.", "Cancelled", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Final confirmation
            Dim confirmMsg = "⚠️ FINAL CONFIRMATION ⚠️" & vbCrLf & vbCrLf &
                           "You are about to reset day-end for ALL incomplete tills." & vbCrLf & vbCrLf &
                           "This will:" & vbCrLf &
                           "1. Mark all incomplete day-ends as complete" & vbCrLf &
                           "2. Allow all POS tills to log in" & vbCrLf &
                           "3. Log this action in the audit trail" & vbCrLf & vbCrLf &
                           "Reason: " & reason & vbCrLf & vbCrLf &
                           "Are you absolutely sure?"
            
            Dim result = MessageBox.Show(confirmMsg, "Confirm Reset", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)
            
            If result <> DialogResult.Yes Then
                Return
            End If
            
            Me.Cursor = Cursors.WaitCursor
            
            ' Perform reset
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim yesterday = DateTime.Today.AddDays(-1)
                
                Dim sql = "
                    UPDATE TillDayEnd 
                    SET IsDayEnd = 1,
                        DayEndTime = GETDATE(),
                        CompletedBy = @AdminUserID,
                        Notes = 'ADMIN RESET: ' + @Reason + ' (Reset by: ' + @AdminUserName + ')'
                    WHERE BusinessDate = @Yesterday 
                    AND IsDayEnd = 0"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Yesterday", yesterday)
                    cmd.Parameters.AddWithValue("@AdminUserID", _adminUserID)
                    cmd.Parameters.AddWithValue("@AdminUserName", _adminUserName)
                    cmd.Parameters.AddWithValue("@Reason", reason)
                    
                    Dim rowsAffected = cmd.ExecuteNonQuery()
                    
                    Me.Cursor = Cursors.Default
                    
                    MessageBox.Show($"✅ Day-end reset successful!" & vbCrLf & vbCrLf &
                                  $"{rowsAffected} till(s) reset." & vbCrLf & vbCrLf &
                                  "All POS tills can now log in.", "Reset Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    ' Refresh the grid
                    LoadIncompleteDayEnds()
                End Using
            End Using
            
        Catch ex As Exception
            Me.Cursor = Cursors.Default
            MessageBox.Show($"Reset failed: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
