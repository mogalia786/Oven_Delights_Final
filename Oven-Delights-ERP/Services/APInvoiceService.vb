Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class APInvoiceService
    Private ReadOnly _connectionString As String

    Public Sub New()
        Try
            Dim connStringConfig = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")
            If connStringConfig Is Nothing Then
                Throw New Exception("Connection string 'OvenDelightsERPConnectionString' not found in App.config")
            End If
            _connectionString = connStringConfig.ConnectionString
            If String.IsNullOrEmpty(_connectionString) Then
                Throw New Exception("Connection string 'OvenDelightsERPConnectionString' is empty")
            End If
        Catch ex As Exception
            Throw New Exception($"Failed to initialize APInvoiceService: {ex.Message}", ex)
        End Try
    End Sub

    Public Function GetOutstandingInvoices(Optional beneficiaryId As Integer? = Nothing,
                                          Optional categoryId As Integer? = Nothing,
                                          Optional dueDateFrom As Date? = Nothing,
                                          Optional dueDateTo As Date? = Nothing) As DataTable
        Dim dt As New DataTable()

        Try
            If String.IsNullOrEmpty(_connectionString) Then
                Throw New Exception("Connection string 'OvenDelightsERPConnectionString' is not configured in App.config")
            End If

            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_AP_GetOutstandingInvoices", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BeneficiaryID", If(beneficiaryId, DBNull.Value))
                    cmd.Parameters.AddWithValue("@CategoryID", If(categoryId, DBNull.Value))
                    cmd.Parameters.AddWithValue("@DueDateFrom", If(dueDateFrom, DBNull.Value))
                    cmd.Parameters.AddWithValue("@DueDateTo", If(dueDateTo, DBNull.Value))

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As SqlException
            Throw New Exception($"Database error in GetOutstandingInvoices: {ex.Message} (Error Number: {ex.Number})", ex)
        Catch ex As Exception
            Throw New Exception($"Error in GetOutstandingInvoices: {ex.Message}", ex)
        End Try

        Return dt
    End Function

    Public Function CreateInvoice(invoiceNumber As String,
                                 beneficiaryId As Integer,
                                 categoryId As Integer,
                                 invoiceDate As Date,
                                 dueDate As Date,
                                 amount As Decimal,
                                 taxAmount As Decimal,
                                 description As String,
                                 reference As String,
                                 createdBy As String,
                                 Optional branchId As Integer = 1) As Integer
        Dim invoiceId As Integer = 0

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_CreateInvoice", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                cmd.Parameters.AddWithValue("@BeneficiaryID", beneficiaryId)
                cmd.Parameters.AddWithValue("@CategoryID", categoryId)
                cmd.Parameters.AddWithValue("@InvoiceDate", invoiceDate)
                cmd.Parameters.AddWithValue("@DueDate", dueDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@TaxAmount", taxAmount)
                cmd.Parameters.AddWithValue("@Description", If(description, DBNull.Value))
                cmd.Parameters.AddWithValue("@Reference", If(reference, DBNull.Value))
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Dim outputParam As New SqlParameter("@InvoiceID", SqlDbType.Int) With {
                    .Direction = ParameterDirection.Output
                }
                cmd.Parameters.Add(outputParam)

                cmd.ExecuteNonQuery()
                invoiceId = CInt(outputParam.Value)
            End Using
        End Using

        Return invoiceId
    End Function

    Public Sub UpdateInvoiceStatus(invoiceId As Integer, status As String, Optional paymentBatchId As Integer? = Nothing, Optional paymentDate As Date? = Nothing)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_UpdateInvoicePaymentStatus", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                cmd.Parameters.AddWithValue("@Status", status)
                cmd.Parameters.AddWithValue("@PaymentBatchID", If(paymentBatchId, DBNull.Value))
                cmd.Parameters.AddWithValue("@PaymentDate", If(paymentDate, DBNull.Value))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Function GetCategories() As DataTable
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_GetCategories", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@IsActive", 1)

                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Public Function GetBeneficiaries() As DataTable
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_GetBeneficiaries", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@IsActive", 1)

                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Public Function CreateBeneficiary(beneficiaryName As String,
                                     beneficiaryType As String,
                                     bankName As String,
                                     branchCode As String,
                                     accountNumber As String,
                                     accountType As String,
                                     Optional contactPerson As String = Nothing,
                                     Optional email As String = Nothing,
                                     Optional phone As String = Nothing,
                                     Optional defaultCategoryId As Integer? = Nothing) As Integer
        Dim beneficiaryId As Integer = 0

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("INSERT INTO AP_Beneficiaries (BeneficiaryName, BeneficiaryType, BankName, BranchCode, AccountNumber, AccountType, ContactPerson, Email, Phone, DefaultCategoryID, IsActive, CreatedDate) VALUES (@BeneficiaryName, @BeneficiaryType, @BankName, @BranchCode, @AccountNumber, @AccountType, @ContactPerson, @Email, @Phone, @DefaultCategoryID, 1, GETDATE()); SELECT SCOPE_IDENTITY()", conn)
                cmd.Parameters.AddWithValue("@BeneficiaryName", beneficiaryName)
                cmd.Parameters.AddWithValue("@BeneficiaryType", beneficiaryType)
                cmd.Parameters.AddWithValue("@BankName", bankName)
                cmd.Parameters.AddWithValue("@BranchCode", branchCode)
                cmd.Parameters.AddWithValue("@AccountNumber", accountNumber)
                cmd.Parameters.AddWithValue("@AccountType", accountType)
                cmd.Parameters.AddWithValue("@ContactPerson", If(contactPerson, DBNull.Value))
                cmd.Parameters.AddWithValue("@Email", If(email, DBNull.Value))
                cmd.Parameters.AddWithValue("@Phone", If(phone, DBNull.Value))
                cmd.Parameters.AddWithValue("@DefaultCategoryID", If(defaultCategoryId, DBNull.Value))

                beneficiaryId = Convert.ToInt32(cmd.ExecuteScalar())
            End Using
        End Using

        Return beneficiaryId
    End Function

    Public Sub UpdateBeneficiary(beneficiaryId As Integer,
                                beneficiaryName As String,
                                beneficiaryType As String,
                                bankName As String,
                                branchCode As String,
                                accountNumber As String,
                                accountType As String,
                                Optional contactPerson As String = Nothing,
                                Optional email As String = Nothing,
                                Optional phone As String = Nothing,
                                Optional defaultCategoryId As Integer? = Nothing)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE AP_Beneficiaries SET BeneficiaryName = @BeneficiaryName, BeneficiaryType = @BeneficiaryType, BankName = @BankName, BranchCode = @BranchCode, AccountNumber = @AccountNumber, AccountType = @AccountType, ContactPerson = @ContactPerson, Email = @Email, Phone = @Phone, DefaultCategoryID = @DefaultCategoryID, ModifiedDate = GETDATE() WHERE BeneficiaryID = @BeneficiaryID", conn)
                cmd.Parameters.AddWithValue("@BeneficiaryID", beneficiaryId)
                cmd.Parameters.AddWithValue("@BeneficiaryName", beneficiaryName)
                cmd.Parameters.AddWithValue("@BeneficiaryType", beneficiaryType)
                cmd.Parameters.AddWithValue("@BankName", bankName)
                cmd.Parameters.AddWithValue("@BranchCode", branchCode)
                cmd.Parameters.AddWithValue("@AccountNumber", accountNumber)
                cmd.Parameters.AddWithValue("@AccountType", accountType)
                cmd.Parameters.AddWithValue("@ContactPerson", If(contactPerson, DBNull.Value))
                cmd.Parameters.AddWithValue("@Email", If(email, DBNull.Value))
                cmd.Parameters.AddWithValue("@Phone", If(phone, DBNull.Value))
                cmd.Parameters.AddWithValue("@DefaultCategoryID", If(defaultCategoryId, DBNull.Value))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Function GenerateInvoiceNumber() As String
        Return "INV-" & DateTime.Now.ToString("yyyyMMddHHmmss")
    End Function

    ''' <summary>
    ''' Post ADHOC invoice to General Ledger
    ''' </summary>
    Public Function PostAdhocInvoiceToGL(invoiceId As Integer,
                                        invoiceNumber As String,
                                        invoiceDate As Date,
                                        supplierName As String,
                                        branchId As Integer,
                                        subtotalAmount As Decimal,
                                        vatAmount As Decimal,
                                        totalAmount As Decimal,
                                        expenseAccountCode As String,
                                        createdBy As Integer) As Integer
        Dim journalId As Integer = 0

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_PostAdhocInvoiceToGL", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                cmd.Parameters.AddWithValue("@InvoiceDate", invoiceDate)
                cmd.Parameters.AddWithValue("@SupplierName", supplierName)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@SubtotalAmount", subtotalAmount)
                cmd.Parameters.AddWithValue("@VATAmount", vatAmount)
                cmd.Parameters.AddWithValue("@TotalAmount", totalAmount)
                cmd.Parameters.AddWithValue("@ExpenseAccountCode", expenseAccountCode)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        journalId = reader.GetInt32(reader.GetOrdinal("JournalID"))
                    End If
                End Using
            End Using
        End Using

        Return journalId
    End Function

    ''' <summary>
    ''' Post single supplier payment to General Ledger
    ''' </summary>
    Public Function PostSinglePaymentToGL(invoiceId As Integer,
                                         paymentNumber As String,
                                         paymentDate As Date,
                                         supplierName As String,
                                         amount As Decimal,
                                         paymentMethod As String,
                                         branchId As Integer,
                                         createdBy As String) As Integer
        Dim journalId As Integer = 0

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_PostSinglePaymentToGL", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                cmd.Parameters.AddWithValue("@PaymentNumber", paymentNumber)
                cmd.Parameters.AddWithValue("@PaymentDate", paymentDate)
                cmd.Parameters.AddWithValue("@SupplierName", supplierName)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        journalId = reader.GetInt32(reader.GetOrdinal("JournalID"))
                    End If
                End Using
            End Using
        End Using

        Return journalId
    End Function

    ''' <summary>
    ''' Post batch payment to General Ledger (called when FNB confirms success)
    ''' </summary>
    Public Sub PostBatchPaymentToGL(batchId As Integer,
                                    paymentDate As Date,
                                    createdBy As String)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_PostBatchPaymentToGL", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@PaymentDate", paymentDate)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Post credit note to General Ledger
    ''' </summary>
    Public Function PostCreditNoteToGL(creditNoteId As Integer,
                                      creditNoteNumber As String,
                                      creditNoteDate As Date,
                                      supplierName As String,
                                      branchId As Integer,
                                      subtotalAmount As Decimal,
                                      vatAmount As Decimal,
                                      totalAmount As Decimal,
                                      expenseAccountCode As String,
                                      createdBy As String) As Integer
        Dim journalId As Integer = 0

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_PostCreditNoteToGL", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@CreditNoteID", creditNoteId)
                cmd.Parameters.AddWithValue("@CreditNoteNumber", creditNoteNumber)
                cmd.Parameters.AddWithValue("@CreditNoteDate", creditNoteDate)
                cmd.Parameters.AddWithValue("@SupplierName", supplierName)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@SubtotalAmount", subtotalAmount)
                cmd.Parameters.AddWithValue("@VATAmount", vatAmount)
                cmd.Parameters.AddWithValue("@TotalAmount", totalAmount)
                cmd.Parameters.AddWithValue("@ExpenseAccountCode", expenseAccountCode)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        journalId = reader.GetInt32(reader.GetOrdinal("JournalID"))
                    End If
                End Using
            End Using
        End Using

        Return journalId
    End Function
End Class
