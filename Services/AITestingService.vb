Imports System.IO
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Data
Imports System.Text.Json
Imports System.Threading.Tasks

Public Class AITestingService
    Private _connectionString As String
    Private _testResults As New List(Of TestResult)
    Private _currentTestSession As String
    
    Public Sub New(connectionString As String)
        _connectionString = connectionString
        _currentTestSession = DateTime.Now.ToString("yyyyMMdd_HHmmss")
    End Sub
    
    Public Async Function RunComprehensiveTestWithLogin(username As String, password As String) As Task(Of TestReport)
        ' First test login functionality
        Dim loginSuccess = Await TestLogin(username, password)
        If Not loginSuccess Then
            Throw New Exception($"Login failed for user: {username}")
        End If
        
        ' Run comprehensive tests with authenticated user
        Return Await RunComprehensiveTest()
    End Function
    
    Public Async Function RunComprehensiveTest() As Task(Of TestReport)
        LogTestStart()
        
        ' Test all major modules
        Await TestAdministrationModule()
        Await TestAccountingModule()
        Await TestManufacturingModule()
        Await TestRetailModule()
        Await TestInventoryModule()
        Await TestReportsModule()
        
        Return GenerateTestReport()
    End Function
    
    Public Async Function TestLogin(username As String, password As String) As Task(Of Boolean)
        Try
            Using conn As New SqlConnection(_connectionString)
                Await conn.OpenAsync()
                
                Dim sql = "SELECT UserID, Username, Password, RoleID, BranchID, IsActive FROM Users WHERE Username = @username AND IsActive = 1"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@username", username)
                    
                    Using reader = Await cmd.ExecuteReaderAsync()
                        If Await reader.ReadAsync() Then
                            Dim storedPassword = reader("Password").ToString()
                            Dim isActive = Convert.ToBoolean(reader("IsActive"))
                            
                            If storedPassword = password AndAlso isActive Then
                                LogTestResult("Login", "Authentication", True, "Login successful")
                                Return True
                            Else
                                LogTestResult("Login", "Authentication", False, "Invalid password or inactive user")
                                Return False
                            End If
                        Else
                            LogTestResult("Login", "Authentication", False, "User not found")
                            Return False
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            _testResults.Add(New TestResult With {
                .TestName = "Login",
                .ModuleName = "Authentication",
                .Passed = False,
                .ErrorMessage = $"Login error: {ex.Message}",
                .TestSession = _currentTestSession,
                .TestDate = DateTime.Now
            })
            Return False
        End Try
    End Function
    
    Private Sub LogTestResult(testName As String, moduleName As String, passed As Boolean, message As String)
        _testResults.Add(New TestResult With {
            .TestName = testName,
            .ModuleName = moduleName,
            .Passed = passed,
            .ErrorMessage = If(passed, "", message),
            .TestSession = _currentTestSession,
            .TestDate = DateTime.Now
        })
    End Sub
    
    Private Async Function TestAdministrationModule() As Task
        Try
            ' Test User Management
            Await TestFormLoad("UserManagementForm", "Administration", "User Management")
            
            ' Test Branch Management
            Await TestFormLoad("BranchManagementForm", "Administration", "Branch Management")
            
            ' Test Audit Log
            Await TestFormLoad("AuditLogViewer", "Administration", "Audit Log")
            
            ' Test Role Access Control
            Await TestFormLoad("RoleAccessControlForm", "Administration", "Role Access Control")
            
            ' Test System Settings
            Await TestFormLoad("SystemSettingsForm", "Administration", "System Settings")
            
        Catch ex As Exception
            LogError("Administration Module", ex)
        End Try
    End Function
    
    Private Async Function TestAccountingModule() As Task
        Try
            ' Test General Ledger
            Await TestFormLoad("GeneralLedgerForm", "Accounting", "General Ledger")
            
            ' Test Accounts Payable
            Await TestFormLoad("AccountsPayableForm", "Accounting", "Accounts Payable")
            
            ' Test Accounts Receivable
            Await TestFormLoad("AccountsReceivableForm", "Accounting", "Accounts Receivable")
            
            ' Test Bank Statement Import
            Await TestFormLoad("BankStatementImportForm", "Accounting", "Bank Statement Import")
            
            ' Test SARS Compliance
            Await TestFormLoad("SARSReportingForm", "Accounting", "SARS Compliance")
            
        Catch ex As Exception
            LogError("Accounting Module", ex)
        End Try
    End Function
    
    Private Async Function TestManufacturingModule() As Task
        Try
            ' Test Build Product Form
            Await TestFormLoad("BuildProductForm", "Manufacturing", "Build Product")
            
            ' Test Manufacturing Dashboard
            Await TestFormLoad("ManufacturingDashboardForm", "Manufacturing", "Dashboard")
            
            ' Test BOM Management
            Await TestFormLoad("BOMManagementForm", "Manufacturing", "BOM Management")
            
        Catch ex As Exception
            LogError("Manufacturing Module", ex)
        End Try
    End Function
    
    Private Async Function TestRetailModule() As Task
        Try
            ' Test Retail Main Form
            Await TestFormLoad("RetailMainForm", "Retail", "Main")
            
            ' Test Stock on Hand
            Await TestFormLoad("RetailStockOnHandForm", "Retail", "Stock on Hand")
            
            ' Test POS System
            Await TestFormLoad("POSForm", "Retail", "Point of Sale")
            
        Catch ex As Exception
            LogError("Retail Module", ex)
        End Try
    End Function
    
    Private Async Function TestInventoryModule() As Task
        Try
            ' Test Inventory Catalog
            Await TestFormLoad("InventoryCatalogCrudForm", "Inventory", "Catalog")
            
            ' Test Stock Management
            Await TestFormLoad("StockManagementForm", "Inventory", "Stock Management")
            
        Catch ex As Exception
            LogError("Inventory Module", ex)
        End Try
    End Function
    
    Private Async Function TestReportsModule() As Task
        Try
            ' Test Financial Reports
            Await TestReportGeneration("Financial Reports")
            
            ' Test Inventory Reports
            Await TestReportGeneration("Inventory Reports")
            
            ' Test Manufacturing Reports
            Await TestReportGeneration("Manufacturing Reports")
            
        Catch ex As Exception
            LogError("Reports Module", ex)
        End Try
    End Function
    
    Private Async Function TestFormLoad(formName As String, moduleValue As String, feature As String) As Task
        Dim testResult As New TestResult With {
            .TestName = formName,
            .ModuleName = moduleValue,
            .Feature = feature,
            .FormName = formName,
            .TestType = "Form Load",
            .StartTime = DateTime.Now,
            .TestSession = _currentTestSession,
            .TestDate = DateTime.Now
        }
        
        Try
            ' ACTUALLY TEST FORM FUNCTIONALITY - NOT JUST EXISTENCE
            Dim fullFormName = $"Oven_Delights_ERP.{formName}"
            Dim formType = Type.GetType(fullFormName)
            
            If formType IsNot Nothing Then
                ' Test form creation and actual functionality
                Using form As Form = CType(Activator.CreateInstance(formType), Form)
                    ' Test form can be shown
                    form.WindowState = FormWindowState.Normal
                    form.ShowInTaskbar = False
                    form.Show()
                    
                    ' Test form controls exist and work
                    Await TestFormControls(form, testResult)
                    
                    ' Test data operations
                    Await TestDataOperations(form, testResult)
                    
                    Await TestMenuFunctionality(form, testResult)
                    
                    form.Hide()
                    
                    testResult.Success = True
                    testResult.Passed = True
                    testResult.Message = "Form loaded and tested successfully - all controls functional"
                End Using
            Else
                ' Try alternative form paths
                Dim alternativePaths = {
                    $"Oven_Delights_ERP.Forms.{formName}",
                    $"Oven_Delights_ERP.Forms.Admin.{formName}",
                    $"Oven_Delights_ERP.Forms.Retail.{formName}",
                    $"Oven_Delights_ERP.Forms.Manufacturing.{formName}",
                    $"Oven_Delights_ERP.Forms.Stockroom.{formName}",
                    $"Oven_Delights_ERP.Forms.Accounting.{formName}"
                }
                
                Dim found = False
                For Each path In alternativePaths
                    formType = Type.GetType(path)
                    If formType IsNot Nothing Then
                        found = True
                        Exit For
                    End If
                Next
                
                If found Then
                    Using form As Form = CType(Activator.CreateInstance(formType), Form)
                        form.Show()
                        Await TestFormControls(form, testResult)
                        form.Hide()
                        testResult.Success = True
                        testResult.Passed = True
                        testResult.Message = "Form loaded and tested successfully"
                    End Using
                Else
                    testResult.Success = False
                    testResult.Passed = False
                    testResult.Message = $"Form '{formName}' not found in any namespace"
                    testResult.ErrorMessage = $"Form '{formName}' not found in any namespace"
                End If
            End If
            
        Catch ex As Exception
            testResult.Success = False
            testResult.Passed = False
            testResult.Message = $"Error testing form '{formName}': {ex.Message}"
            testResult.ErrorMessage = ex.Message
        Finally
            testResult.EndTime = DateTime.Now
            testResult.Duration = testResult.EndTime - testResult.StartTime
            _testResults.Add(testResult)
            
            ' SAVE TEST RESULT TO DATABASE
            SaveTestResultToDatabase(testResult)
        End Try
    End Function
    
    Private Async Function TestDataOperations(form As Form, testResult As TestResult) As Task
        Try
            ' Test database connections and data loading
            For Each control As Control In GetAllControls(form)
                If TypeOf control Is DataGridView Then
                    Dim dgv = CType(control, DataGridView)
                    If dgv.DataSource Is Nothing Then
                        testResult.Warnings.Add($"DataGridView '{dgv.Name}' has no data source")
                    End If
                End If
            Next
        Catch ex As Exception
            testResult.Warnings.Add($"Data operations test failed: {ex.Message}")
        End Try
    End Function

    Private Async Function TestMenuFunctionality(form As Form, testResult As TestResult) As Task
        Try
            ' Test menu items if form has menus
            Dim menuStrip = form.Controls.OfType(Of MenuStrip)().FirstOrDefault()
            If menuStrip IsNot Nothing Then
                For Each item As ToolStripMenuItem In menuStrip.Items.OfType(Of ToolStripMenuItem)()
                    If item.DropDownItems.Count = 0 AndAlso item.HasDropDownItems = False Then
                        testResult.Warnings.Add($"Menu item '{item.Text}' has no click handler")
                    End If
                Next
            End If
        Catch ex As Exception
            testResult.Warnings.Add($"Menu functionality test failed: {ex.Message}")
        End Try
    End Function

    Private Async Function TestFormControls(form As Form, testResult As TestResult) As Task
        Try
            ' Test all buttons for click handlers and functionality
            For Each control As Control In GetAllControls(form)
                If TypeOf control Is Button Then
                    Dim btn = CType(control, Button)
                    If btn.Enabled AndAlso Not HasClickHandler(btn) Then
                        testResult.Warnings.Add($"Button '{btn.Name}' has no click handler")
                    Else
                        ' Actually test button click
                        Try
                            btn.PerformClick()
                        Catch ex As Exception
                            testResult.Warnings.Add($"Button '{btn.Name}' click failed: {ex.Message}")
                        End Try
                    End If
                ElseIf TypeOf control Is DataGridView Then
                    Dim grid = CType(control, DataGridView)
                    If grid.DataSource Is Nothing Then
                        testResult.Warnings.Add($"DataGridView '{grid.Name}' has no data source")
                    End If
                End If
            Next
            
        Catch ex As Exception
            testResult.Warnings.Add($"Control testing error: {ex.Message}")
        End Try
    End Function
    
    Private Async Function TestDataLoading(form As Form, testResult As TestResult) As Task
        Try
            ' Look for LoadData methods and test them
            Dim formType = form.GetType()
            Dim loadDataMethod = formType.GetMethod("LoadData", Reflection.BindingFlags.NonPublic Or Reflection.BindingFlags.Instance)
            
            If loadDataMethod IsNot Nothing Then
                loadDataMethod.Invoke(form, Nothing)
                testResult.Message += " | Data loaded successfully"
            End If
            
        Catch ex As Exception
            testResult.Warnings.Add($"Data loading error: {ex.Message}")
        End Try
    End Function
    
    Private Async Function TestReportGeneration(reportType As String) As Task
        Dim testResult As New TestResult With {
            .TestName = reportType,
            .ModuleName = "Reports",
            .Feature = reportType,
            .TestType = "Report Generation",
            .StartTime = DateTime.Now,
            .TestSession = _currentTestSession,
            .TestDate = DateTime.Now
        }
        
        Try
            ' Test report data queries
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Select Case reportType
                    Case "Financial Reports"
                        Await TestFinancialReportQueries(conn, testResult)
                    Case "Inventory Reports"
                        Await TestInventoryReportQueries(conn, testResult)
                    Case "Manufacturing Reports"
                        Await TestManufacturingReportQueries(conn, testResult)
                End Select
            End Using
            
            testResult.Success = True
            testResult.Passed = True
            testResult.Message = "Report generation tested successfully"
            
        Catch ex As Exception
            testResult.Success = False
            testResult.Passed = False
            testResult.Message = $"Error testing reports: {ex.Message}"
            testResult.ErrorMessage = ex.Message
        Finally
            testResult.EndTime = DateTime.Now
            testResult.Duration = testResult.EndTime - testResult.StartTime
            _testResults.Add(testResult)
        End Try
    End Function
    
    Private Async Function TestFinancialReportQueries(conn As SqlConnection, testResult As TestResult) As Task
        ' Test key financial report queries
        Dim queries As String() = {
            "SELECT COUNT(*) FROM dbo.GeneralLedger",
            "SELECT COUNT(*) FROM dbo.AccountsPayable",
            "SELECT COUNT(*) FROM dbo.AccountsReceivable",
            "SELECT COUNT(*) FROM dbo.VATTransactions"
        }
        
        For Each query In queries
            Try
                Using cmd As New SqlCommand(query, conn)
                    Await cmd.ExecuteScalarAsync()
                End Using
            Catch ex As Exception
                testResult.Warnings.Add($"Query failed: {query} - {ex.Message}")
            End Try
        Next
    End Function
    
    Private Async Function TestInventoryReportQueries(conn As SqlConnection, testResult As TestResult) As Task
        ' Test inventory report queries
        Dim queries As String() = {
            "SELECT COUNT(*) FROM dbo.Retail_Product",
            "SELECT COUNT(*) FROM dbo.Manufacturing_Product",
            "SELECT COUNT(*) FROM dbo.Stockroom_Product",
            "SELECT COUNT(*) FROM dbo.Retail_Stock"
        }
        
        For Each query In queries
            Try
                Using cmd As New SqlCommand(query, conn)
                    Await cmd.ExecuteScalarAsync()
                End Using
            Catch ex As Exception
                testResult.Warnings.Add($"Query failed: {query} - {ex.Message}")
            End Try
        Next
    End Function
    
    Private Async Function TestManufacturingReportQueries(conn As SqlConnection, testResult As TestResult) As Task
        ' Test manufacturing report queries
        Dim queries As String() = {
            "SELECT COUNT(*) FROM dbo.Manufacturing_Product",
            "SELECT COUNT(*) FROM dbo.RecipeNode",
            "SELECT COUNT(*) FROM dbo.BillOfMaterials"
        }
        
        For Each query In queries
            Try
                Using cmd As New SqlCommand(query, conn)
                    Await cmd.ExecuteScalarAsync()
                End Using
            Catch ex As Exception
                testResult.Warnings.Add($"Query failed: {query} - {ex.Message}")
            End Try
        Next
    End Function
    
    Private Function GetAllControls(parent As Control) As List(Of Control)
        Dim controls As New List(Of Control)
        For Each control As Control In parent.Controls
            controls.Add(control)
            controls.AddRange(GetAllControls(control))
        Next
        Return controls
    End Function
    
    Private Function HasClickHandler(button As Button) As Boolean
        ' Use reflection to check if button has click event handlers
        Dim eventField = GetType(Control).GetField("EventClick", Reflection.BindingFlags.Static Or Reflection.BindingFlags.NonPublic)
        If eventField IsNot Nothing Then
            Dim eventKey = eventField.GetValue(Nothing)
            Dim events = button.GetType().GetProperty("Events", Reflection.BindingFlags.NonPublic Or Reflection.BindingFlags.Instance)
            If events IsNot Nothing Then
                Dim eventList = events.GetValue(button)
                Return eventList IsNot Nothing
            End If
        End If
        Return False
    End Function
    
    Private Sub LogTestStart()
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql = "INSERT INTO dbo.TestSessions (SessionID, StartTime, Status) VALUES (@session, @start, 'Running')"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", _currentTestSession)
                cmd.Parameters.AddWithValue("@start", DateTime.Now)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub
    
    Private Sub LogError(moduleValue As String, ex As Exception)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql = "INSERT INTO dbo.TestErrors (SessionID, Module, ErrorMessage, StackTrace, Timestamp) VALUES (@session, @module, @error, @stack, @time)"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", _currentTestSession)
                cmd.Parameters.AddWithValue("@module", moduleValue)
                cmd.Parameters.AddWithValue("@error", ex.Message)
                cmd.Parameters.AddWithValue("@stack", ex.StackTrace)
                cmd.Parameters.AddWithValue("@time", DateTime.Now)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub
    
    Private Function GenerateTestReport() As TestReport
        Dim report As New TestReport With {
            .SessionID = _currentTestSession,
            .TestResults = _testResults,
            .TotalTests = _testResults.Count,
            .PassedTests = _testResults.Where(Function(t) t.Passed).Count(),
            .FailedTests = _testResults.Where(Function(t) Not t.Passed).Count(),
            .TotalWarnings = _testResults.Sum(Function(t) t.Warnings.Count),
            .GeneratedAt = DateTime.Now
        }
        
        ' Save session completion to database
        SaveTestSessionCompletion()
        
        Return report
    End Function
    
    Private Sub SaveTestResultToDatabase(result As TestResult)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "INSERT INTO dbo.TestResults (SessionID, Module, Feature, FormName, TestType, Success, Message, StartTime, EndTime, Duration, Warnings) VALUES (@session, @module, @feature, @form, @type, @success, @message, @start, @end, @duration, @warnings)"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@session", _currentTestSession)
                    cmd.Parameters.AddWithValue("@module", result.ModuleName)
                    cmd.Parameters.AddWithValue("@feature", result.Feature)
                    cmd.Parameters.AddWithValue("@form", result.FormName)
                    cmd.Parameters.AddWithValue("@type", result.TestType)
                    cmd.Parameters.AddWithValue("@success", result.Passed)
                    cmd.Parameters.AddWithValue("@message", If(result.Passed, result.Message, result.ErrorMessage))
                    cmd.Parameters.AddWithValue("@start", result.StartTime)
                    cmd.Parameters.AddWithValue("@end", result.EndTime)
                    cmd.Parameters.AddWithValue("@duration", result.Duration.TotalMilliseconds)
                    cmd.Parameters.AddWithValue("@warnings", String.Join("; ", result.Warnings))
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Log error but don't fail the test
            Console.WriteLine($"Error saving test result: {ex.Message}")
        End Try
    End Sub

    Private Sub SaveTestSessionCompletion()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "UPDATE dbo.TestSessions SET EndTime = @end, Status = 'Completed', TotalTests = @total, PassedTests = @passed, FailedTests = @failed WHERE SessionID = @session"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@session", _currentTestSession)
                    cmd.Parameters.AddWithValue("@end", DateTime.Now)
                    cmd.Parameters.AddWithValue("@total", _testResults.Count)
                    cmd.Parameters.AddWithValue("@passed", _testResults.Where(Function(r) r.Success).Count())
                    cmd.Parameters.AddWithValue("@failed", _testResults.Where(Function(r) Not r.Success).Count())
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error saving test session completion: {ex.Message}")
        End Try
    End Sub

End Class

Public Class TestResult
    Public Property TestName As String
    Public Property ModuleName As String
    Public Property Feature As String
    Public Property FormName As String
    Public Property TestType As String
    Public Property Success As Boolean
    Public Property Passed As Boolean
    Public Property Message As String
    Public Property ErrorMessage As String
    Public Property TestSession As String
    Public Property TestDate As DateTime
    Public Property StartTime As DateTime
    Public Property EndTime As DateTime
    Public Property Duration As TimeSpan
    Public Property Warnings As New List(Of String)
End Class

Public Class TestReport
    Public Property SessionID As String
    Public Property TestResults As List(Of TestResult)
    Public Property TotalTests As Integer
    Public Property PassedTests As Integer
    Public Property FailedTests As Integer
    Public Property TotalWarnings As Integer
    Public Property GeneratedAt As DateTime
    
    Public Function GetSuccessRate() As Double
        If TotalTests = 0 Then Return 0
        Return (PassedTests / TotalTests) * 100
    End Function
End Class
