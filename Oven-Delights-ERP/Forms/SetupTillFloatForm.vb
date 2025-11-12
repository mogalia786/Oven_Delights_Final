Imports System.Data.SqlClient
Imports System.Configuration

Public Class SetupTillFloatForm
    Private ReadOnly _connectionString As String
    Private _floatData As DataTable
    Private _currentBranchID As Integer
    Private _currentBranchName As String

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        ' Get current logged-in branch from app settings or session
        _currentBranchID = GetCurrentBranchID()
        _currentBranchName = GetCurrentBranchName()
    End Sub

    Private Function GetCurrentBranchID() As Integer
        ' Get from AppSession (global application state)
        If AppSession.CurrentBranchID > 0 Then
            Return AppSession.CurrentBranchID
        End If
        
        ' Fallback: Get from first active branch
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT TOP 1 BranchID FROM Branches WHERE IsActive = 1 ORDER BY BranchID"
                Using cmd As New SqlCommand(sql, conn)
                    Dim result = cmd.ExecuteScalar()
                    Return If(result IsNot Nothing, CInt(result), 1)
                End Using
            End Using
        Catch
            Return 1
        End Try
    End Function

    Private Function GetCurrentBranchName() As String
        ' Get from AppSession first
        If Not String.IsNullOrEmpty(AppSession.CurrentBranchName) Then
            Return AppSession.CurrentBranchName
        End If
        
        ' Fallback: Query database
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT BranchName FROM Branches WHERE BranchID = @BranchID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    Dim result = cmd.ExecuteScalar()
                    Return If(result IsNot Nothing, result.ToString(), "Unknown Branch")
                End Using
            End Using
        Catch
            Return "Unknown Branch"
        End Try
    End Function

    Private Sub SetupTillFloatForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Show current branch
            lblTitle.Text = $"Setup Till Cash Float - {_currentBranchName}"
            
            ' Hide branch filter controls since we're branch-specific
            If pnlFilter.Controls.Contains(cboBranch) Then cboBranch.Visible = False
            If pnlFilter.Controls.Contains(lblBranch) Then lblBranch.Visible = False
            If pnlFilter.Controls.Contains(btnShowAll) Then btnShowAll.Visible = False
            
            LoadFloatConfiguration()
        Catch ex As Exception
            MessageBox.Show($"Error loading form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadFloatConfiguration()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Get all tills for current branch and their float configs
                Dim sql = "
                    SELECT 
                        ISNULL(tfc.FloatConfigID, 0) AS FloatConfigID,
                        @BranchID AS BranchID,
                        tp.TillPointID,
                        tp.TillNumber AS TillPointName,
                        ISNULL(tfc.FloatAmount, 0.00) AS FloatAmount,
                        ISNULL(tfc.IsActive, 1) AS IsActive,
                        tfc.ModifiedDate,
                        tfc.ModifiedBy
                    FROM TillPoints tp
                    LEFT JOIN TillFloatConfig tfc ON tp.TillPointID = tfc.TillPointID AND tfc.BranchID = @BranchID
                    WHERE tp.BranchID = @BranchID AND tp.IsActive = 1
                    ORDER BY tp.TillNumber"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    Using adapter As New SqlDataAdapter(cmd)
                        _floatData = New DataTable()
                        adapter.Fill(_floatData)
                        dgvFloatConfig.DataSource = _floatData
                        
                        ' Format grid
                        FormatGrid()
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading float configuration: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        With dgvFloatConfig
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            .SelectionMode = DataGridViewSelectionMode.CellSelect
            .MultiSelect = False
            .ReadOnly = False
            .AllowUserToAddRows = False
            .AllowUserToDeleteRows = False
            
            ' Hide ID columns
            If .Columns.Contains("FloatConfigID") Then
                .Columns("FloatConfigID").Visible = False
            End If
            
            If .Columns.Contains("BranchID") Then
                .Columns("BranchID").Visible = False
            End If
            
            ' Format columns
            If .Columns.Contains("TillPointID") Then
                .Columns("TillPointID").HeaderText = "Till ID"
                .Columns("TillPointID").Width = 100
                .Columns("TillPointID").ReadOnly = True
                .Columns("TillPointID").DefaultCellStyle.BackColor = Color.LightGray
            End If
            
            If .Columns.Contains("TillPointName") Then
                .Columns("TillPointName").HeaderText = "Till Point"
                .Columns("TillPointName").Width = 150
                .Columns("TillPointName").ReadOnly = True
                .Columns("TillPointName").DefaultCellStyle.BackColor = Color.LightGray
            End If
            
            If .Columns.Contains("FloatAmount") Then
                .Columns("FloatAmount").HeaderText = "Daily Float Amount (R)"
                .Columns("FloatAmount").DefaultCellStyle.Format = "N2"
                .Columns("FloatAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                .Columns("FloatAmount").DefaultCellStyle.BackColor = Color.LightYellow
                .Columns("FloatAmount").ReadOnly = False
            End If
            
            If .Columns.Contains("IsActive") Then
                .Columns("IsActive").Visible = False
            End If
            
            If .Columns.Contains("ModifiedDate") Then
                .Columns("ModifiedDate").HeaderText = "Last Updated"
                .Columns("ModifiedDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
                .Columns("ModifiedDate").ReadOnly = True
                .Columns("ModifiedDate").DefaultCellStyle.BackColor = Color.LightGray
            End If
            
            If .Columns.Contains("ModifiedBy") Then
                .Columns("ModifiedBy").HeaderText = "Updated By"
                .Columns("ModifiedBy").ReadOnly = True
                .Columns("ModifiedBy").DefaultCellStyle.BackColor = Color.LightGray
            End If
        End With
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            SaveChanges()
            MessageBox.Show("Float configuration saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadFloatConfiguration()
        Catch ex As Exception
            MessageBox.Show($"Error saving changes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SaveChanges()
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using transaction = conn.BeginTransaction()
                Try
                    For Each row As DataRow In _floatData.Rows
                        If row.RowState = DataRowState.Modified Then
                            Dim floatConfigID = CInt(row("FloatConfigID"))
                            Dim tillPointID = CInt(row("TillPointID"))
                            Dim floatAmount = CDec(row("FloatAmount"))
                            
                            If floatConfigID = 0 Then
                                ' INSERT - No float config exists yet for this till
                                Dim insertSQL = "
                                    INSERT INTO TillFloatConfig (BranchID, TillPointID, FloatAmount, IsActive, CreatedBy, CreatedDate)
                                    VALUES (@BranchID, @TillPointID, @FloatAmount, 1, @CreatedBy, GETDATE())"
                                
                                Using cmd As New SqlCommand(insertSQL, conn, transaction)
                                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                                    cmd.Parameters.AddWithValue("@TillPointID", tillPointID)
                                    cmd.Parameters.AddWithValue("@FloatAmount", floatAmount)
                                    cmd.Parameters.AddWithValue("@CreatedBy", Environment.UserName)
                                    cmd.ExecuteNonQuery()
                                End Using
                            Else
                                ' UPDATE - Float config already exists
                                Dim updateSQL = "
                                    UPDATE TillFloatConfig 
                                    SET FloatAmount = @FloatAmount,
                                        ModifiedDate = GETDATE(),
                                        ModifiedBy = @ModifiedBy
                                    WHERE FloatConfigID = @FloatConfigID"
                                
                                Using cmd As New SqlCommand(updateSQL, conn, transaction)
                                    cmd.Parameters.AddWithValue("@FloatAmount", floatAmount)
                                    cmd.Parameters.AddWithValue("@ModifiedBy", Environment.UserName)
                                    cmd.Parameters.AddWithValue("@FloatConfigID", floatConfigID)
                                    cmd.ExecuteNonQuery()
                                End Using
                            End If
                        End If
                    Next
                    
                    transaction.Commit()
                Catch
                    transaction.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
