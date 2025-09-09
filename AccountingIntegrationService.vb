Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class AccountingIntegrationService
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    ' User Creation → Journal Entry for setup costs
    Public Sub CreateUserAccountingEntry(userID As Integer, username As String, branchID As Integer?, createdBy As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' Create journal entry for user setup costs
                Dim setupCost As Decimal = 150.0 ' Standard user setup cost
                Dim costCenter As String = GetBranchCostCenter(branchID)
                
                Dim query As String = "
                    INSERT INTO AccountingJournals 
                    (JournalType, ReferenceID, ReferenceTable, DebitAccount, CreditAccount, Amount, Description, CreatedBy)
                    VALUES 
                    (@JournalType, @ReferenceID, @ReferenceTable, @DebitAccount, @CreditAccount, @Amount, @Description, @CreatedBy)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@JournalType", "UserCreation")
                    command.Parameters.AddWithValue("@ReferenceID", userID)
                    command.Parameters.AddWithValue("@ReferenceTable", "Users")
                    command.Parameters.AddWithValue("@DebitAccount", "6100") ' IT Setup Expenses
                    command.Parameters.AddWithValue("@CreditAccount", "2100") ' Accounts Payable
                    command.Parameters.AddWithValue("@Amount", setupCost)
                    command.Parameters.AddWithValue("@Description", $"User setup costs for {username} - {costCenter}")
                    command.Parameters.AddWithValue("@CreatedBy", createdBy)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Log error but don't fail user creation
            LogError("CreateUserAccountingEntry", ex.Message)
        End Try
    End Sub

    ' Login tracking → Time & Attendance integration
    Public Sub CreateLoginAccountingEntry(userID As Integer, username As String, loginTime As DateTime)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    INSERT INTO AccountingJournals 
                    (JournalType, ReferenceID, ReferenceTable, DebitAccount, CreditAccount, Amount, Description, CreatedBy)
                    VALUES 
                    (@JournalType, @ReferenceID, @ReferenceTable, @DebitAccount, @CreditAccount, @Amount, @Description, @CreatedBy)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@JournalType", "LoginTracking")
                    command.Parameters.AddWithValue("@ReferenceID", userID)
                    command.Parameters.AddWithValue("@ReferenceTable", "UserSessions")
                    command.Parameters.AddWithValue("@DebitAccount", "5200") ' Labor Costs
                    command.Parameters.AddWithValue("@CreditAccount", "2200") ' Accrued Wages
                    command.Parameters.AddWithValue("@Amount", 0) ' Time tracking, no immediate cost
                    command.Parameters.AddWithValue("@Description", $"Login tracked for {username} at {loginTime:yyyy-MM-dd HH:mm}")
                    command.Parameters.AddWithValue("@CreatedBy", userID)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            LogError("CreateLoginAccountingEntry", ex.Message)
        End Try
    End Sub

    ' Branch setup creates cost centers
    Public Sub CreateBranchAccountingEntry(branchID As Integer, branchName As String, branchCode As String, createdBy As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' Create cost center setup entry
                Dim setupCost As Decimal = 5000.0 ' Branch setup cost
                
                Dim query As String = "
                    INSERT INTO AccountingJournals 
                    (JournalType, ReferenceID, ReferenceTable, DebitAccount, CreditAccount, Amount, Description, CreatedBy)
                    VALUES 
                    (@JournalType, @ReferenceID, @ReferenceTable, @DebitAccount, @CreditAccount, @Amount, @Description, @CreatedBy)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@JournalType", "BranchSetup")
                    command.Parameters.AddWithValue("@ReferenceID", branchID)
                    command.Parameters.AddWithValue("@ReferenceTable", "Branches")
                    command.Parameters.AddWithValue("@DebitAccount", "1500") ' Fixed Assets - Branch Setup
                    command.Parameters.AddWithValue("@CreditAccount", "2100") ' Accounts Payable
                    command.Parameters.AddWithValue("@Amount", setupCost)
                    command.Parameters.AddWithValue("@Description", $"Branch setup costs for {branchName} ({branchCode})")
                    command.Parameters.AddWithValue("@CreatedBy", createdBy)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            LogError("CreateBranchAccountingEntry", ex.Message)
        End Try
    End Sub

    ' Password changes → Security compliance costs
    Public Sub CreatePasswordChangeEntry(userID As Integer, username As String)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    INSERT INTO AccountingJournals 
                    (JournalType, ReferenceID, ReferenceTable, DebitAccount, CreditAccount, Amount, Description, CreatedBy)
                    VALUES 
                    (@JournalType, @ReferenceID, @ReferenceTable, @DebitAccount, @CreditAccount, @Amount, @Description, @CreatedBy)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@JournalType", "SecurityCompliance")
                    command.Parameters.AddWithValue("@ReferenceID", userID)
                    command.Parameters.AddWithValue("@ReferenceTable", "Users")
                    command.Parameters.AddWithValue("@DebitAccount", "6200") ' Security Expenses
                    command.Parameters.AddWithValue("@CreditAccount", "2300") ' Accrued Expenses
                    command.Parameters.AddWithValue("@Amount", 5.0) ' Security compliance cost
                    command.Parameters.AddWithValue("@Description", $"Password security update for {username}")
                    command.Parameters.AddWithValue("@CreatedBy", userID)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            LogError("CreatePasswordChangeEntry", ex.Message)
        End Try
    End Sub

    ' Session timeout → Productivity tracking
    Public Sub CreateSessionTimeoutEntry(userID As Integer, username As String, sessionDuration As TimeSpan)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim productivityHours As Decimal = CDec(sessionDuration.TotalHours)
                Dim hourlyRate As Decimal = 25.0 ' Standard hourly rate
                Dim productivityValue As Decimal = productivityHours * hourlyRate
                
                Dim query As String = "
                    INSERT INTO AccountingJournals 
                    (JournalType, ReferenceID, ReferenceTable, DebitAccount, CreditAccount, Amount, Description, CreatedBy)
                    VALUES 
                    (@JournalType, @ReferenceID, @ReferenceTable, @DebitAccount, @CreditAccount, @Amount, @Description, @CreatedBy)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@JournalType", "ProductivityTracking")
                    command.Parameters.AddWithValue("@ReferenceID", userID)
                    command.Parameters.AddWithValue("@ReferenceTable", "UserSessions")
                    command.Parameters.AddWithValue("@DebitAccount", "4100") ' Revenue - Productivity
                    command.Parameters.AddWithValue("@CreditAccount", "5200") ' Labor Costs
                    command.Parameters.AddWithValue("@Amount", productivityValue)
                    command.Parameters.AddWithValue("@Description", $"Productivity tracking for {username}: {productivityHours:F2} hours")
                    command.Parameters.AddWithValue("@CreatedBy", userID)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            LogError("CreateSessionTimeoutEntry", ex.Message)
        End Try
    End Sub

    Private Function GetBranchCostCenter(branchID As Integer?) As String
        If Not branchID.HasValue Then Return "CC000"
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT CostCenterCode FROM Branches WHERE BranchID = @BranchID"
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@BranchID", branchID.Value)
                    Dim result = command.ExecuteScalar()
                    Return If(result IsNot Nothing, result.ToString(), "CC000")
                End Using
            End Using
        Catch ex As Exception
            Return "CC000"
        End Try
    End Function

    Private Sub LogError(method As String, errorMessage As String)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "
                    INSERT INTO AuditLog (Action, TableName, OldValues, Timestamp)
                    VALUES (@Action, @TableName, @ErrorMessage, GETDATE())"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Action", "ACCOUNTING_ERROR")
                    command.Parameters.AddWithValue("@TableName", "AccountingJournals")
                    command.Parameters.AddWithValue("@ErrorMessage", $"{method}: {errorMessage}")
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch
            ' Silent error logging failure
        End Try
    End Sub

    ' Get accounting summary for dashboard
    Public Function GetAccountingSummary() As Dictionary(Of String, Object)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim summary As New Dictionary(Of String, Object)
                
                ' Total journal entries
                Dim totalQuery As String = "SELECT COUNT(*) FROM AccountingJournals"
                Using command As New SqlCommand(totalQuery, connection)
                    summary("TotalJournalEntries") = command.ExecuteScalar()
                End Using
                
                ' Total amounts by type
                Dim amountQuery As String = "
                    SELECT JournalType, SUM(Amount) as TotalAmount 
                    FROM AccountingJournals 
                    GROUP BY JournalType"
                
                Using command As New SqlCommand(amountQuery, connection)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            summary(reader("JournalType").ToString() & "_Total") = reader("TotalAmount")
                        End While
                    End Using
                End Using
                
                Return summary
            End Using
        Catch ex As Exception
            Return New Dictionary(Of String, Object) From {{"Error", ex.Message}}
        End Try
    End Function
End Class
