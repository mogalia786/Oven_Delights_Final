Imports System.Data.SqlClient

Public Class LedgerPostingHelper
    
    ''' <summary>
    ''' Posts a transaction to the appropriate ledger with correct debit/credit logic
    ''' </summary>
    Public Shared Sub PostToLedger(conn As SqlConnection, trans As SqlTransaction, 
                                   ledgerType As String, 
                                   entityId As Integer, 
                                   transactionType As String, 
                                   amount As Decimal, 
                                   transactionDate As Date, 
                                   reference As String, 
                                   description As String)
        
        Dim debitAmount As Decimal = 0
        Dim creditAmount As Decimal = 0
        
        ' Determine debit/credit based on ledger type and transaction type
        Select Case ledgerType.ToUpper()
            Case "SUPPLIER"
                ' Supplier Ledger (Liability Account - Normal Balance: CREDIT)
                Select Case transactionType.ToUpper()
                    Case "INVOICE", "DEBIT NOTE"
                        ' Increases liability = CREDIT
                        creditAmount = amount
                    Case "PAYMENT", "CREDIT NOTE"
                        ' Decreases liability = DEBIT
                        debitAmount = amount
                End Select
                
                Dim cmd As New SqlCommand("INSERT INTO SupplierLedger (SupplierID, TransactionType, TransactionDate, ReferenceNumber, Description, DebitAmount, CreditAmount) VALUES (@EntityID, @TransactionType, @TransactionDate, @Reference, @Description, @DebitAmount, @CreditAmount)", conn, trans)
                cmd.Parameters.AddWithValue("@EntityID", entityId)
                cmd.Parameters.AddWithValue("@TransactionType", transactionType)
                cmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
                cmd.Parameters.AddWithValue("@Reference", reference)
                cmd.Parameters.AddWithValue("@Description", description)
                cmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                cmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                cmd.ExecuteNonQuery()
                
            Case "CUSTOMER"
                ' Customer Ledger (Asset Account - Normal Balance: DEBIT)
                Select Case transactionType.ToUpper()
                    Case "INVOICE", "DEBIT NOTE"
                        ' Increases asset = DEBIT
                        debitAmount = amount
                    Case "PAYMENT", "CREDIT NOTE"
                        ' Decreases asset = CREDIT
                        creditAmount = amount
                End Select
                
                Dim cmd As New SqlCommand("INSERT INTO CustomerLedger (CustomerID, TransactionType, TransactionDate, ReferenceNumber, Description, DebitAmount, CreditAmount) VALUES (@EntityID, @TransactionType, @TransactionDate, @Reference, @Description, @DebitAmount, @CreditAmount)", conn, trans)
                cmd.Parameters.AddWithValue("@EntityID", entityId)
                cmd.Parameters.AddWithValue("@TransactionType", transactionType)
                cmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
                cmd.Parameters.AddWithValue("@Reference", reference)
                cmd.Parameters.AddWithValue("@Description", description)
                cmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                cmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                cmd.ExecuteNonQuery()
                
            Case "GENERAL"
                ' General Ledger - requires account code to determine normal balance
                ' This will be handled separately with account type lookup
                Throw New NotImplementedException("Use PostToGeneralLedger for GL postings")
                
        End Select
    End Sub
    
    ''' <summary>
    ''' Posts to General Ledger with automatic debit/credit determination based on account type
    ''' </summary>
    Public Shared Sub PostToGeneralLedger(conn As SqlConnection, trans As SqlTransaction,
                                         accountId As Integer,
                                         transactionType As String,
                                         amount As Decimal,
                                         transactionDate As Date,
                                         reference As String,
                                         description As String,
                                         isIncrease As Boolean)
        
        ' Get account type to determine normal balance
        Dim accountType As String = ""
        Dim normalBalance As String = ""
        
        Dim acctCmd As New SqlCommand("SELECT AccountType, NormalBalance FROM ChartOfAccounts WHERE AccountID = @AccountID", conn, trans)
        acctCmd.Parameters.AddWithValue("@AccountID", accountId)
        
        Using reader = acctCmd.ExecuteReader()
            If reader.Read() Then
                accountType = reader("AccountType").ToString()
                normalBalance = If(reader("NormalBalance") IsNot DBNull.Value, reader("NormalBalance").ToString(), "")
            End If
        End Using
        
        Dim debitAmount As Decimal = 0
        Dim creditAmount As Decimal = 0
        
        ' Determine debit/credit based on account normal balance and whether it's an increase/decrease
        ' Assets & Expenses: Normal Balance = DEBIT (increase=debit, decrease=credit)
        ' Liabilities, Equity & Revenue: Normal Balance = CREDIT (increase=credit, decrease=debit)
        
        If normalBalance = "DR" OrElse accountType = "Asset" OrElse accountType = "Expense" Then
            ' Debit normal balance accounts
            If isIncrease Then
                debitAmount = amount
            Else
                creditAmount = amount
            End If
        Else
            ' Credit normal balance accounts (Liability, Equity, Revenue)
            If isIncrease Then
                creditAmount = amount
            Else
                debitAmount = amount
            End If
        End If
        
        Dim cmd As New SqlCommand("INSERT INTO GeneralLedger (AccountID, TransactionDate, ReferenceNumber, Description, DebitAmount, CreditAmount) VALUES (@AccountID, @TransactionDate, @Reference, @Description, @DebitAmount, @CreditAmount)", conn, trans)
        cmd.Parameters.AddWithValue("@AccountID", accountId)
        cmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
        cmd.Parameters.AddWithValue("@Reference", reference)
        cmd.Parameters.AddWithValue("@Description", description)
        cmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
        cmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
        cmd.ExecuteNonQuery()
    End Sub
    
End Class
