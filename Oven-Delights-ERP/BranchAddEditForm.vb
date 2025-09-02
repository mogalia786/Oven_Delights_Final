Imports System
Imports System.Windows.Forms
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Oven_Delights_ERP.Logging

Imports System.Diagnostics
Imports System.Data
Imports System.Text

Partial Class BranchAddEditForm
    Inherits Form

    ' Form controls (declared in Designer)
    Private ReadOnly _branchService As New BranchService()
    Private _branch As Branch
    Private ReadOnly _currentUserId As Integer
    Private ReadOnly _isEditMode As Boolean = False
    Private ReadOnly _connectionString As String
    Private ReadOnly _logger As ILogger = New DebugLogger()
    Private WithEvents ErrorProvider1 As New ErrorProvider()

    ' Service and data members

    Public Sub New(currentUserId As Integer)
        Try
            InitializeComponent()
            _currentUserId = currentUserId
            _isEditMode = False
            Me.Text = "Add New Branch"
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            If String.IsNullOrEmpty(_connectionString) Then
                Throw New ConfigurationErrorsException("Database connection string is not configured.")
            End If
            InitializeForm()
        Catch ex As Exception
            _logger.LogError($"Error initializing BranchAddEditForm: {ex.Message}")
            MessageBox.Show($"Failed to initialize form: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Try
    End Sub

    Public Sub New(branchId As Integer, currentUserId As Integer)
        Try
            InitializeComponent()
            _currentUserId = currentUserId
            _isEditMode = True
            Me.Text = "Edit Branch"
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            If String.IsNullOrEmpty(_connectionString) Then
                Throw New ConfigurationErrorsException("Database connection string is not configured.")
            End If
            
            _branch = _branchService.GetBranchById(branchId)
            If _branch Is Nothing Then
                MessageBox.Show("Branch not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.DialogResult = DialogResult.Cancel
                Me.Close()
                Return
            End If
            InitializeForm()
        Catch ex As Exception
            _logger.LogError($"Error initializing BranchAddEditForm (Edit Mode): {ex.Message}")
            MessageBox.Show($"Failed to initialize form: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Try
    End Sub
    
    Private Sub InitializeForm()
        Try
            ' Set up form controls with appropriate max lengths
            txtName.MaxLength = 100
            txtBranchCode.MaxLength = 20
            txtPrefix.MaxLength = 10
            txtAddress.MaxLength = 255
            txtCity.MaxLength = 100
            txtProvince.MaxLength = 100
            txtPostalCode.MaxLength = 20
            txtPhone.MaxLength = 20
            txtEmail.MaxLength = 100
            txtManager.MaxLength = 100
            
            ' Set up validation
            AddHandler txtName.Validating, AddressOf ValidateRequiredField
            AddHandler txtBranchCode.Validating, AddressOf ValidateBranchCode
            AddHandler txtPrefix.Validating, AddressOf ValidatePrefix
            AddHandler txtEmail.Validating, AddressOf ValidateEmail
            AddHandler txtPhone.Validating, AddressOf ValidatePhone
            
            ' Format input
            AddHandler txtPostalCode.KeyPress, AddressOf TextBox_KeyPress_AlphaNumeric
            AddHandler txtBranchCode.KeyPress, AddressOf TextBox_KeyPress_AlphaNumeric
            AddHandler txtPrefix.KeyPress, AddressOf TextBox_KeyPress_AlphaNumeric
            
            ' Auto-format prefix to uppercase
            AddHandler txtName.TextChanged, AddressOf txtName_TextChanged
            AddHandler txtPrefix.Leave, Sub(s, e) txtPrefix.Text = txtPrefix.Text.Trim().ToUpper()
            
            ' Set default values for new branches
            If Not _isEditMode Then
                txtBranchCode.Text = GenerateBranchCode("")
                txtPrefix.Text = GenerateBranchPrefix("")
                chkIsActive.Checked = True
            End If
            
            ' Load data if in edit mode
            If _isEditMode AndAlso _branch IsNot Nothing Then
                LoadBranchData()
            End If
            
            ' Set focus to first field
            If Not txtName.Focused Then txtName.Focus()
            
        Catch ex As Exception
            _logger.LogError($"Error initializing form: {ex.Message}")
            MessageBox.Show($"Failed to initialize form: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Try
    End Sub
    
    Private Sub txtName_TextChanged(sender As Object, e As EventArgs) Handles txtName.TextChanged
        Try
            ' Only auto-generate for new branches and if fields are empty or match previous auto-generated values
            If Not _isEditMode Then
                ' Only update if the user hasn't manually changed the branch code
                If String.IsNullOrEmpty(txtBranchCode.Text) OrElse 
                   txtBranchCode.Text = GenerateBranchCode("") Then
                    txtBranchCode.Text = GenerateBranchCode(txtName.Text)
                End If
                
                ' Only update if the user hasn't manually changed the prefix
                If String.IsNullOrEmpty(txtPrefix.Text) OrElse 
                   txtPrefix.Text = GenerateBranchPrefix("") Then
                    txtPrefix.Text = GenerateBranchPrefix(txtName.Text)
                End If
            End If
        Catch ex As Exception
            _logger.LogError($"Error in txtName_TextChanged: {ex.Message}")
            ' Don't show error to user for this non-critical operation
        End Try
    End Sub
    
    Private Function GenerateBranchCode(branchName As String) As String
        Try
            If String.IsNullOrWhiteSpace(branchName) Then Return "BR" & DateTime.Now.ToString("yyMM")
            
            ' Take first 3 characters of each word and join with underscore
            Dim words = branchName.Split({" "c, "-"c, "_"c, "."c, ","c, ";"c, ":"c, "/"c, "\"c, "|"c, "~"c, "`"c, "!"c, "@"c, "#"c, "$"c, "%"c, "^"c, "&"c, "*"c, "("c, ")"c, "+"c, "="c, "{"c, "}"c, "["c, "]"c, "'"c, "<"c, ">"c, "?"c}, StringSplitOptions.RemoveEmptyEntries)
            
            ' Process first 3 words
            Dim codeBuilder As New System.Text.StringBuilder()
            For Each word In words.Take(3)
                If word.Length > 3 Then
                    codeBuilder.Append(word.Substring(0, 3))
                Else
                    codeBuilder.Append(word)
                End If
            Next
            
            ' Remove any remaining non-alphanumeric characters and convert to uppercase
            Dim code = codeBuilder.ToString()
            code = New String((From c In code Where Char.IsLetterOrDigit(c)).ToArray()).ToUpper()
            
            ' Ensure at least 2 characters
            If code.Length < 2 Then
                code = "BR" & DateTime.Now.ToString("yyMM")
            End If
            
            ' Ensure max length of 20 characters
            Return code.Substring(0, Math.Min(20, code.Length))
            
        Catch ex As Exception
            _logger.LogError($"Error generating branch code: {ex.Message}")
            Return "BR" & DateTime.Now.ToString("yyMMddHHmmss")
        End Try
    End Function
    
    Private Function GenerateBranchPrefix(branchName As String) As String
        Try
            If String.IsNullOrWhiteSpace(branchName) Then Return "BR"
            
            ' Take first 2-3 characters of each word and join with dash
            Dim words = branchName.Split({" "c, "-"c, "_"c, "."c, ","c, ";"c, ":"c, "/"c, "\"c, "|"c, "~"c, "`"c, "!"c, "@"c, "#"c, "$"c, "%"c, "^"c, "&"c, "*"c, "("c, ")"c, "+"c, "="c, "{"c, "}"c, "["c, "]"c, "'"c, "<"c, ">"c, "?"c}, StringSplitOptions.RemoveEmptyEntries)
            
            ' Process first 2 words
            Dim prefixBuilder As New System.Text.StringBuilder()
            For Each word In words.Take(2)
                If word.Length > 2 Then
                    prefixBuilder.Append(word.Substring(0, 2))
                Else
                    prefixBuilder.Append(word)
                End If
            Next
            
            Dim prefix = prefixBuilder.ToString()
            
            ' Remove any remaining non-alphanumeric characters and convert to uppercase
            prefix = New String(prefix.Where(Function(c) Char.IsLetterOrDigit(c)).ToArray()).ToUpper()
            
            ' Ensure at least 1 character and max 10 characters
            If String.IsNullOrEmpty(prefix) Then
                prefix = "BR"
            Else
                prefix = prefix.Substring(0, Math.Min(10, Math.Max(1, prefix.Length)))
            End If
            
            Return prefix
            
        Catch ex As Exception
            _logger.LogError($"Error generating branch prefix: {ex.Message}")
            Return "BR"
        End Try
    End Function
    
    ' Validation methods
    Private Sub ValidateBranchCode(sender As Object, e As System.ComponentModel.CancelEventArgs)
        Dim textBox = DirectCast(sender, TextBox)
        If String.IsNullOrWhiteSpace(textBox.Text) Then
            ErrorProvider1.SetError(textBox, "Branch code is required")
            e.Cancel = True
        ElseIf Not System.Text.RegularExpressions.Regex.IsMatch(textBox.Text, "^[A-Z0-9]+$") Then
            ErrorProvider1.SetError(textBox, "Branch code can only contain letters and numbers")
            e.Cancel = True
        Else
            ErrorProvider1.SetError(textBox, String.Empty)
        End If
    End Sub
    
    Private Sub ValidatePrefix(sender As Object, e As System.ComponentModel.CancelEventArgs)
        Dim textBox = DirectCast(sender, TextBox)
        If String.IsNullOrWhiteSpace(textBox.Text) Then
            ErrorProvider1.SetError(textBox, "Prefix is required")
            e.Cancel = True
        ElseIf Not System.Text.RegularExpressions.Regex.IsMatch(textBox.Text, "^[A-Z0-9]{1,10}$") Then
            ErrorProvider1.SetError(textBox, "Prefix must be 1-10 alphanumeric characters")
            e.Cancel = True
        Else
            ErrorProvider1.SetError(textBox, String.Empty)
        End If
    End Sub
    
    Private Sub ValidateRequiredField(sender As Object, e As System.ComponentModel.CancelEventArgs)
        Dim textBox = DirectCast(sender, TextBox)
        If String.IsNullOrWhiteSpace(textBox.Text) Then
            ErrorProvider1.SetError(textBox, $"{textBox.Tag} is required")
            e.Cancel = True
        Else
            ErrorProvider1.SetError(textBox, String.Empty)
        End If
    End Sub
    
    Private Sub ValidateEmail(sender As Object, e As System.ComponentModel.CancelEventArgs)
        Dim textBox = DirectCast(sender, TextBox)
        If String.IsNullOrWhiteSpace(textBox.Text) Then
            ErrorProvider1.SetError(textBox, "Email is required")
            e.Cancel = True
            Return
        End If
        
        Try
            Dim addr = New System.Net.Mail.MailAddress(textBox.Text)
            If addr.Address <> textBox.Text.Trim() Then
                Throw New FormatException()
            End If
            ErrorProvider1.SetError(textBox, String.Empty)
        Catch
            ErrorProvider1.SetError(textBox, "Please enter a valid email address")
            e.Cancel = True
        End Try
    End Sub
    
    Private Sub ValidatePhone(sender As Object, e As System.ComponentModel.CancelEventArgs)
        Dim textBox = DirectCast(sender, TextBox)
        If String.IsNullOrWhiteSpace(textBox.Text) Then
            ErrorProvider1.SetError(textBox, "Phone number is required")
            e.Cancel = True
            Return
        End If
        
        ' Basic phone number validation (allows numbers, spaces, +, -, (, ) )
        If Not System.Text.RegularExpressions.Regex.IsMatch(textBox.Text, "^[0-9+()\- ]+$") Then
            ErrorProvider1.SetError(textBox, "Please enter a valid phone number")
            e.Cancel = True
            Return
        End If
        
        ErrorProvider1.SetError(textBox, String.Empty)
    End Sub
    
    Private Function IsValidEmail(email As String) As Boolean
        If String.IsNullOrWhiteSpace(email) Then Return True
        
        Try
            Dim addr = New System.Net.Mail.MailAddress(email)
            Return addr.Address = email
        Catch
            Return False
        End Try
    End Function
    
    ' Input formatting
    Private Sub TextBox_KeyPress_AlphaNumeric(sender As Object, e As KeyPressEventArgs)
        ' Allow control characters (backspace, delete, etc.)
        If Char.IsControl(e.KeyChar) Then Return
        
        ' Allow letters, digits, and common symbols
        If Not (Char.IsLetterOrDigit(e.KeyChar) OrElse " -_/\\".Contains(e.KeyChar)) Then
            e.Handled = True
        End If
    End Sub

    Private Sub LoadBranchData()
        Try
            If _branch IsNot Nothing Then
                ' Load basic branch information
                txtName.Text = _branch.BranchName
                txtBranchCode.Text = _branch.BranchCode
                txtPrefix.Text = _branch.Prefix
                txtAddress.Text = _branch.Address
                txtCity.Text = _branch.City
                txtProvince.Text = _branch.Province
                txtPostalCode.Text = _branch.PostalCode
                txtPhone.Text = _branch.Phone
                txtEmail.Text = _branch.Email
                txtManager.Text = _branch.ManagerName
                chkIsActive.Checked = _branch.IsActive
                
                ' Set form title for edit mode
                Me.Text = $"Edit Branch - {_branch.BranchName}"
                
                ' Disable branch code field in edit mode (should not be changed after creation)
                txtBranchCode.Enabled = False
                
                ' Log successful load
                _logger.LogInformation($"Loaded branch data for {_branch.BranchName} (ID: {_branch.ID})")
            Else
                _logger.LogWarning("Attempted to load branch data but _branch is Nothing")
                MessageBox.Show("Error: Branch data not found", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.DialogResult = DialogResult.Cancel
                Me.Close()
            End If
        Catch ex As Exception
            _logger.LogError($"Error loading branch data: {ex.Message}")
            MessageBox.Show($"Failed to load branch data: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Try
    End Sub

    ' Event handlers for form controls
    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            If Not ValidateForm() Then Return
            
            Dim success As Boolean
            If _isEditMode Then
                success = SaveBranch()
                If success Then
                    _logger.LogInformation($"Branch {_branch.ID} updated successfully by user {_currentUserId}")
                    MessageBox.Show("Branch updated successfully!", "Success", 
                                  MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            Else
                success = SaveBranch()
                If success Then
                    _logger.LogInformation($"New branch created successfully by user {_currentUserId}")
                    MessageBox.Show("Branch created successfully!", "Success", 
                                  MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            End If
        Catch ex As Exception
            _logger.LogError($"Error saving branch: {ex.Message}")
            MessageBox.Show($"An error occurred while saving the branch: {ex.Message}", 
                          "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function ValidateForm() As Boolean
        ' Reset error provider
        ErrorProvider1.Clear()
        
        ' Validate required fields
        If String.IsNullOrWhiteSpace(txtName.Text) Then
            ErrorProvider1.SetError(txtName, "Branch name is required")
            txtName.Focus()
            Return False
        End If
        
        If String.IsNullOrWhiteSpace(txtAddress.Text) Then
            ErrorProvider1.SetError(txtAddress, "Address is required")
            txtAddress.Focus()
            Return False
        End If
        
        If String.IsNullOrWhiteSpace(txtPhone.Text) Then
            ErrorProvider1.SetError(txtPhone, "Phone is required")
            txtPhone.Focus()
            Return False
        End If
        
        ' Validate email format if provided
        If Not String.IsNullOrWhiteSpace(txtEmail.Text) AndAlso Not IsValidEmail(txtEmail.Text) Then
            ErrorProvider1.SetError(txtEmail, "Please enter a valid email address")
            txtEmail.Focus()
            Return False
        End If
        
        Return True
    End Function

    Private Function SaveBranch() As Boolean
        Try
            ' Validate all required fields before proceeding
            If Not ValidateAllFields() Then Return False
            
            ' Create or update branch object
            If _isEditMode AndAlso _branch IsNot Nothing Then
                ' Update existing branch
                _branch.BranchName = txtName.Text.Trim()
                _branch.BranchCode = txtBranchCode.Text.Trim()
                _branch.Prefix = txtPrefix.Text.Trim().ToUpper()
                _branch.Address = txtAddress.Text.Trim()
                _branch.City = txtCity.Text.Trim()
                _branch.Province = txtProvince.Text.Trim()
                _branch.PostalCode = txtPostalCode.Text.Trim()
                _branch.Phone = txtPhone.Text.Trim()
                _branch.Email = txtEmail.Text.Trim()
                _branch.ManagerName = txtManager.Text.Trim()
                _branch.IsActive = chkIsActive.Checked
                _branch.ModifiedBy = _currentUserId
                _branch.ModifiedDate = DateTime.Now
                
                ' Log the update
                _logger.LogInformation($"Updating branch: {_branch.BranchName} (ID: {_branch.ID})")
            Else
                ' Create new branch
                _branch = New Branch() With {
                    .BranchName = txtName.Text.Trim(),
                    .BranchCode = txtBranchCode.Text.Trim(),
                    .Prefix = txtPrefix.Text.Trim().ToUpper(),
                    .Address = txtAddress.Text.Trim(),
                    .City = txtCity.Text.Trim(),
                    .Province = txtProvince.Text.Trim(),
                    .PostalCode = txtPostalCode.Text.Trim(),
                    .Phone = txtPhone.Text.Trim(),
                    .Email = txtEmail.Text.Trim(),
                    .ManagerName = txtManager.Text.Trim(),
                    .IsActive = chkIsActive.Checked,
                    .CreatedBy = _currentUserId,
                    .CreatedDate = DateTime.Now
                }
                
                ' Log the creation
                _logger.LogInformation($"Creating new branch: {_branch.BranchName}")
            End If
            
            ' Save branch with all required parameters
            Dim result = _branchService.SaveBranch(
                If(_isEditMode, _branch.ID, 0), ' branchId
                _branch.BranchCode,
                _branch.BranchName,
                _branch.Prefix,
                _branch.Address,
                _branch.City,
                _branch.Province,
                _branch.PostalCode,
                _branch.Phone,
                _branch.Email,
                _branch.ManagerName,
                _branch.IsActive,
                _currentUserId)
            
            ' Log the result
            If result Then
                _logger.LogInformation($"Branch {(If(_isEditMode, "updated", "created"))} successfully")
            Else
                _logger.LogWarning($"Failed to save branch: {_branch.BranchName}")
            End If
            
            Return result
            
        Catch ex As Exception
            Dim errorMsg = $"Error {(If(_isEditMode, "updating", "creating"))} branch: {ex.Message}"
            _logger.LogError($"{errorMsg} - {ex.StackTrace}")
            MessageBox.Show(errorMsg, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End Try
    End Function
    
    Private Function ValidateAllFields() As Boolean
        ' Clear previous errors
        ErrorProvider1.Clear()
        
        ' Validate required fields
        If String.IsNullOrWhiteSpace(txtName.Text) Then
            ErrorProvider1.SetError(txtName, "Branch name is required")
            txtName.Focus()
            Return False
        End If
        
        If String.IsNullOrWhiteSpace(txtBranchCode.Text) Then
            ErrorProvider1.SetError(txtBranchCode, "Branch code is required")
            txtBranchCode.Focus()
            Return False
        End If
        
        If String.IsNullOrWhiteSpace(txtPrefix.Text) Then
            ErrorProvider1.SetError(txtPrefix, "Prefix is required")
            txtPrefix.Focus()
            Return False
        End If
        
        ' Validate email format if provided
        If Not String.IsNullOrWhiteSpace(txtEmail.Text) AndAlso Not IsValidEmail(txtEmail.Text) Then
            ErrorProvider1.SetError(txtEmail, "Please enter a valid email address")
            txtEmail.Focus()
            Return False
        End If
        
        ' Validate phone number format if provided
        If Not String.IsNullOrWhiteSpace(txtPhone.Text) AndAlso 
           Not System.Text.RegularExpressions.Regex.IsMatch(txtPhone.Text, "^[0-9+()\- ]+$") Then
            ErrorProvider1.SetError(txtPhone, "Please enter a valid phone number")
            txtPhone.Focus()
            Return False
        End If
        
        ' Validate prefix format (alphanumeric, 1-10 chars)
        If Not System.Text.RegularExpressions.Regex.IsMatch(txtPrefix.Text, "^[A-Z0-9]{1,10}$") Then
            ErrorProvider1.SetError(txtPrefix, "Prefix must be 1-10 alphanumeric characters")
            txtPrefix.Focus()
            Return False
        End If
        
        ' Validate branch code format (alphanumeric)
        If Not System.Text.RegularExpressions.Regex.IsMatch(txtBranchCode.Text, "^[A-Z0-9]+$") Then
            ErrorProvider1.SetError(txtBranchCode, "Branch code can only contain letters and numbers")
            txtBranchCode.Focus()
            Return False
        End If
        
        Return True
    End Function



    ' GenerateBranchCode, GenerateBranchPrefix, and GenerateCostCenterCode methods are defined earlier in the file

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer?, details As String)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim query As String = """
                    INSERT INTO AuditLog 
                        (UserID, Action, TableName, RecordID, Details, Timestamp) 
                    VALUES 
                        (@userID, @action, @tableName, @recordID, @details, GETDATE())
                """
                
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@userID", _currentUserId)
                    cmd.Parameters.AddWithValue("@action", action)
                    cmd.Parameters.AddWithValue("@tableName", tableName)
                    cmd.Parameters.AddWithValue("@recordID", If(recordID.HasValue, recordID.Value, DBNull.Value))
                    cmd.Parameters.AddWithValue("@details", If(String.IsNullOrEmpty(details), DBNull.Value, details))
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Log error but don't throw - audit logging failure shouldn't prevent main operation
            _logger.LogError($"Error logging audit action: {ex.Message}")
        End Try
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    ' Form validation and helper methods
End Class
