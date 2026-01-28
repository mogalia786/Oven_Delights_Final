Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class GeneralLedgerService
    Private ReadOnly _connectionString As String

    Public Event LogMessage(message As String)

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' =============================================
    ' Create Journal Entry
    ' =============================================
    Public Function CreateJournal(journalDate As Date, reference As String, description As String, 
                                  branchId As Integer?, createdBy As String, 
                                  Optional autoPost As Boolean = True) As Integer
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_CreateJournal", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                    cmd.Parameters.AddWithValue("@Reference", If(reference, DBNull.Value))
                    cmd.Parameters.AddWithValue("@Description", description)
                    cmd.Parameters.AddWithValue("@BranchID", If(branchId, DBNull.Value))
                    cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                    cmd.Parameters.AddWithValue("@AutoPost", autoPost)
                    
                    Dim outputParam As New SqlParameter("@JournalID", SqlDbType.Int)
                    outputParam.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(outputParam)
                    
                    cmd.ExecuteNonQuery()
                    
                    Return CInt(outputParam.Value)
                End Using
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error creating journal: {ex.Message}")
            Throw
        End Try
    End Function

    ' =============================================
    ' Add Journal Line
    ' =============================================
    Public Sub AddJournalLine(journalId As Integer, accountCode As String, 
                             debit As Decimal, credit As Decimal,
                             Optional description As String = Nothing,
                             Optional reference1 As String = Nothing,
                             Optional reference2 As String = Nothing)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_AddJournalLine", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@JournalID", journalId)
                    cmd.Parameters.AddWithValue("@AccountCode", accountCode)
                    cmd.Parameters.AddWithValue("@Debit", debit)
                    cmd.Parameters.AddWithValue("@Credit", credit)
                    cmd.Parameters.AddWithValue("@Description", If(description, DBNull.Value))
                    cmd.Parameters.AddWithValue("@Reference1", If(reference1, DBNull.Value))
                    cmd.Parameters.AddWithValue("@Reference2", If(reference2, DBNull.Value))
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error adding journal line: {ex.Message}")
            Throw
        End Try
    End Sub

    ' =============================================
    ' Post Journal
    ' =============================================
    Public Sub PostJournal(journalId As Integer, postedBy As String)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_PostJournal", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@JournalID", journalId)
                    cmd.Parameters.AddWithValue("@PostedBy", postedBy)
                    
                    cmd.ExecuteNonQuery()
                    RaiseEvent LogMessage($"Journal {journalId} posted successfully")
                End Using
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error posting journal: {ex.Message}")
            Throw
        End Try
    End Sub


    ' =============================================
    ' Quick Post - Simplified journal posting
    ' =============================================
    Public Function QuickPost(journalDate As Date, description As String, 
                             debitAccount As String, creditAccount As String, 
                             amount As Decimal, reference As String,
                             branchId As Integer?, createdBy As String) As Integer
        Try
            Dim lines As New List(Of JournalLineItem) From {
                New JournalLineItem With {
                    .AccountCode = debitAccount,
                    .Debit = amount,
                    .Credit = 0,
                    .Description = description,
                    .Reference1 = reference
                },
                New JournalLineItem With {
                    .AccountCode = creditAccount,
                    .Debit = 0,
                    .Credit = amount,
                    .Description = description,
                    .Reference1 = reference
                }
            }
            
            Return PostCompleteJournal(journalDate, reference, description, branchId, lines, createdBy)
        Catch ex As Exception
            RaiseEvent LogMessage($"Error in quick post: {ex.Message}")
            Throw
        End Try
    End Function

    ' =============================================
    ' Get Trial Balance
    ' =============================================
    Public Function GetTrialBalance(asOfDate As Date?, branchId As Integer?, 
                                    includeZeroBalances As Boolean) As DataTable
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_GetTrialBalance", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@AsOfDate", If(asOfDate, DBNull.Value))
                    cmd.Parameters.AddWithValue("@BranchID", If(branchId, DBNull.Value))
                    cmd.Parameters.AddWithValue("@IncludeZeroBalances", includeZeroBalances)
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    Return dt
                End Using
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error getting trial balance: {ex.Message}")
            Throw
        End Try
    End Function

    ' =============================================
    ' Get Profit & Loss
    ' =============================================
    Public Function GetProfitLoss(fromDate As Date, toDate As Date, branchId As Integer?) As DataTable
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_GetProfitLoss", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@FromDate", fromDate)
                    cmd.Parameters.AddWithValue("@ToDate", toDate)
                    cmd.Parameters.AddWithValue("@BranchID", If(branchId, DBNull.Value))
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    Return dt
                End Using
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error getting profit & loss: {ex.Message}")
            Throw
        End Try
    End Function

    ' =============================================
    ' Get Balance Sheet
    ' =============================================
    Public Function GetBalanceSheet(asOfDate As Date?, branchId As Integer?) As DataTable
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_GetBalanceSheet", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@AsOfDate", If(asOfDate, DBNull.Value))
                    cmd.Parameters.AddWithValue("@BranchID", If(branchId, DBNull.Value))
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    Return dt
                End Using
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error getting balance sheet: {ex.Message}")
            Throw
        End Try
    End Function

    ' =============================================
    ' Get Account Ledger
    ' =============================================
    Public Function GetAccountLedger(accountCode As String, fromDate As Date, toDate As Date, Optional branchId As Integer? = Nothing) As DataTable
        Dim dt As New DataTable()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GL_GetAccountLedger", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@AccountCode", accountCode)
                    cmd.Parameters.AddWithValue("@FromDate", fromDate)
                    cmd.Parameters.AddWithValue("@ToDate", toDate)
                    If branchId.HasValue Then
                        cmd.Parameters.AddWithValue("@BranchID", branchId.Value)
                    End If
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error getting account ledger: {ex.Message}", ex)
        End Try
        
        Return dt
    End Function

    ''' <summary>
    ''' Post a complete journal entry with multiple lines (for manual journal entry)
    ''' </summary>
    Public Function PostCompleteJournal(
        journalDate As Date,
        reference As String,
        description As String,
        branchId As Integer?,
        lines As List(Of JournalLineItem),
        createdBy As String
    ) As Integer
        Dim journalId As Integer = 0
        
        Try
            ' Validate that debits equal credits
            Dim totalDebits = lines.Sum(Function(l) l.Debit)
            Dim totalCredits = lines.Sum(Function(l) l.Credit)
            
            If Math.Abs(totalDebits - totalCredits) > 0.01D Then
                Throw New Exception($"Journal does not balance. Debits: {totalDebits:N2}, Credits: {totalCredits:N2}")
            End If
            
            ' Create journal (don't auto-post)
            journalId = CreateJournal(journalDate, reference, description, branchId, createdBy, False)
            
            ' Add all lines
            For Each line In lines
                AddJournalLine(journalId, line.AccountCode, line.Debit, line.Credit, line.Description, line.Reference1, line.Reference2)
            Next
            
            ' Post the journal
            PostJournal(journalId, createdBy)
            
            RaiseEvent LogMessage($"Complete journal posted: JournalID={journalId}, Debits={totalDebits:N2}, Credits={totalCredits:N2}")
            
            Return journalId
        Catch ex As Exception
            RaiseEvent LogMessage($"Error posting complete journal: {ex.Message}")
            Throw
        End Try
    End Function
End Class

''' <summary>
''' Helper class for journal line items
''' </summary>
Public Class JournalLineItem
    Public Property AccountCode As String
    Public Property Debit As Decimal
    Public Property Credit As Decimal
    Public Property Description As String
    Public Property Reference1 As String
    Public Property Reference2 As String
End Class
