# OUTLOOK AUTO-FILE PROOF OF PAYMENTS - VBA MACRO SOLUTION

## Overview
Automatically organize FNB proof of payment emails into beneficiary-specific folders in Outlook 2013 by matching beneficiary names from the ERP database. The macro also saves email attachments (PDF proof of payments) to disk folders organized by beneficiary.

---

## Solution Architecture

### Components:
1. **Outlook VBA Macro** - Runs automatically when emails arrive
2. **ERP Database Connection** - Reads beneficiary list from `AP_Beneficiaries` table
3. **Folder Management** - Auto-creates Outlook folders and disk folders for each beneficiary
4. **Email Matching** - Matches beneficiary names in email subject/body
5. **Attachment Extraction** - Saves PDF/image attachments to disk folders
6. **Auto-Filing** - Moves matched emails to correct beneficiary folder

---

## Prerequisites

### Software Requirements:
- Outlook 2013 (or later)
- SQL Server connection to ERP database
- Macro security enabled in Outlook

### Database Requirements:
- Access to `AP_Beneficiaries` table in ERP database
- Connection string: `OvenDelightsERPConnectionString`

### Email Requirements:
- FNB proof of payment emails must contain beneficiary name in subject or body
- Emails should come from a consistent FNB sender address

---

## Implementation Steps

### STEP 1: Enable Macros in Outlook

1. Open Outlook 2013
2. Go to **File** → **Options** → **Trust Center** → **Trust Center Settings**
3. Click **Macro Settings**
4. Select **"Notifications for all macros"** or **"Enable all macros"**
5. Click **OK** and restart Outlook

---

### STEP 2: Open VBA Editor

1. In Outlook, press **Alt + F11** to open VBA Editor
2. In the left pane, expand **"Microsoft Outlook Objects"**
3. Double-click **"ThisOutlookSession"**

---

### STEP 3: Add Database Reference

1. In VBA Editor, go to **Tools** → **References**
2. Check the following references:
   - ✅ Microsoft ActiveX Data Objects 2.8 Library (or latest)
   - ✅ Microsoft Scripting Runtime
3. Click **OK**

---

### STEP 4: Paste VBA Macro Code

Copy and paste the following code into the **ThisOutlookSession** module:

```vba
Option Explicit

' ========================================
' AUTO-FILE FNB PROOF OF PAYMENTS
' ========================================
' This macro automatically files FNB proof of payment emails
' into beneficiary-specific folders based on ERP database
' AND saves attachments to disk folders

Private WithEvents inboxItems As Outlook.Items
Private Const ROOT_FOLDER_NAME As String = "Proof of Payments"
Private Const FNB_SENDER_EMAIL As String = "@fnb.co.za" ' Adjust based on actual FNB sender

' File system root path for saving attachments
Private Const ATTACHMENTS_ROOT_PATH As String = "C:\ProofOfPayments\"

' Connection string to ERP database
Private Const CONN_STRING As String = "Provider=SQLOLEDB;Data Source=ovendelights.database.windows.net;" & _
                                     "Initial Catalog=OvenDelightsERP;" & _
                                     "User ID=OvenDelightsAdmin;" & _
                                     "Password=@Ovendelights2024;"

' ========================================
' STARTUP: Initialize when Outlook starts
' ========================================
Private Sub Application_Startup()
    Dim ns As Outlook.NameSpace
    Set ns = Application.GetNamespace("MAPI")
    Set inboxItems = ns.GetDefaultFolder(olFolderInbox).Items
    Set ns = Nothing
End Sub

' ========================================
' EVENT: Triggered when new email arrives
' ========================================
Private Sub inboxItems_ItemAdd(ByVal Item As Object)
    On Error Resume Next
    
    If TypeOf Item Is Outlook.MailItem Then
        Dim mail As Outlook.MailItem
        Set mail = Item
        
        ' Check if email is from FNB
        If InStr(1, mail.SenderEmailAddress, FNB_SENDER_EMAIL, vbTextCompare) > 0 Or _
           InStr(1, mail.Subject, "Proof of Payment", vbTextCompare) > 0 Or _
           InStr(1, mail.Subject, "Payment Confirmation", vbTextCompare) > 0 Then
            
            ProcessProofOfPayment mail
        End If
    End If
End Sub

' ========================================
' MAIN LOGIC: Process proof of payment email
' ========================================
Private Sub ProcessProofOfPayment(mail As Outlook.MailItem)
    On Error GoTo ErrorHandler
    
    Dim beneficiaryName As String
    Dim targetFolder As Outlook.Folder
    
    ' Match beneficiary name from email
    beneficiaryName = MatchBeneficiaryFromEmail(mail)
    
    If beneficiaryName <> "" Then
        ' Save attachments to disk first
        SaveAttachmentsToDisk mail, beneficiaryName
        
        ' Get or create beneficiary folder
        Set targetFolder = GetOrCreateBeneficiaryFolder(beneficiaryName)
        
        ' Move email to beneficiary folder
        If Not targetFolder Is Nothing Then
            mail.Move targetFolder
            Debug.Print "Moved email to folder: " & beneficiaryName
        End If
    Else
        Debug.Print "No beneficiary match found for email: " & mail.Subject
    End If
    
    Exit Sub
    
ErrorHandler:
    Debug.Print "Error processing email: " & Err.Description
End Sub

' ========================================
' MATCH BENEFICIARY: Find beneficiary name in email
' ========================================
Private Function MatchBeneficiaryFromEmail(mail As Outlook.MailItem) As String
    On Error GoTo ErrorHandler
    
    Dim conn As Object
    Dim rs As Object
    Dim sql As String
    Dim beneficiaryName As String
    Dim emailContent As String
    
    ' Combine subject and body for searching
    emailContent = mail.Subject & " " & mail.Body
    
    ' Connect to ERP database
    Set conn = CreateObject("ADODB.Connection")
    conn.Open CONN_STRING
    
    ' Query all active beneficiaries
    sql = "SELECT BeneficiaryName FROM AP_Beneficiaries WHERE IsActive = 1 ORDER BY LEN(BeneficiaryName) DESC"
    
    Set rs = CreateObject("ADODB.Recordset")
    rs.Open sql, conn
    
    ' Loop through beneficiaries and find match
    Do While Not rs.EOF
        beneficiaryName = Trim(rs.Fields("BeneficiaryName").Value)
        
        ' Check if beneficiary name appears in email (case-insensitive)
        If InStr(1, emailContent, beneficiaryName, vbTextCompare) > 0 Then
            MatchBeneficiaryFromEmail = beneficiaryName
            Exit Do
        End If
        
        rs.MoveNext
    Loop
    
    rs.Close
    conn.Close
    Set rs = Nothing
    Set conn = Nothing
    
    Exit Function
    
ErrorHandler:
    MatchBeneficiaryFromEmail = ""
    If Not rs Is Nothing Then rs.Close
    If Not conn Is Nothing Then conn.Close
End Function

' ========================================
' FOLDER MANAGEMENT: Get or create beneficiary folder
' ========================================
Private Function GetOrCreateBeneficiaryFolder(beneficiaryName As String) As Outlook.Folder
    On Error Resume Next
    
    Dim ns As Outlook.NameSpace
    Dim inbox As Outlook.Folder
    Dim rootFolder As Outlook.Folder
    Dim beneficiaryFolder As Outlook.Folder
    
    Set ns = Application.GetNamespace("MAPI")
    Set inbox = ns.GetDefaultFolder(olFolderInbox)
    
    ' Get or create root "Proof of Payments" folder
    Set rootFolder = inbox.Folders(ROOT_FOLDER_NAME)
    If rootFolder Is Nothing Then
        Set rootFolder = inbox.Folders.Add(ROOT_FOLDER_NAME, olFolderInbox)
    End If
    
    ' Get or create beneficiary-specific folder
    Set beneficiaryFolder = rootFolder.Folders(beneficiaryName)
    If beneficiaryFolder Is Nothing Then
        Set beneficiaryFolder = rootFolder.Folders.Add(beneficiaryName, olFolderInbox)
    End If
    
    Set GetOrCreateBeneficiaryFolder = beneficiaryFolder
    Set ns = Nothing
End Function

' ========================================
' SAVE ATTACHMENTS: Save email attachments to disk
' ========================================
Private Sub SaveAttachmentsToDisk(mail As Outlook.MailItem, beneficiaryName As String)
    On Error GoTo ErrorHandler
    
    Dim fso As Object
    Dim att As Outlook.Attachment
    Dim folderPath As String
    Dim fileName As String
    Dim filePath As String
    Dim timestamp As String
    Dim fileExt As String
    Dim savedCount As Integer
    
    ' Check if email has attachments
    If mail.Attachments.Count = 0 Then
        Exit Sub
    End If
    
    ' Create FileSystemObject
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Create beneficiary folder path
    folderPath = ATTACHMENTS_ROOT_PATH & SanitizeFolderName(beneficiaryName) & "\"
    
    ' Create folder if it doesn't exist
    If Not fso.FolderExists(folderPath) Then
        CreateFolderPath folderPath
    End If
    
    ' Generate timestamp for unique filenames
    timestamp = Format(Now, "yyyymmdd_hhnnss")
    savedCount = 0
    
    ' Loop through attachments
    For Each att In mail.Attachments
        ' Get file extension
        fileExt = LCase(fso.GetExtensionName(att.FileName))
        
        ' Only save PDF, PNG, JPG, JPEG files (proof of payment formats)
        If fileExt = "pdf" Or fileExt = "png" Or fileExt = "jpg" Or fileExt = "jpeg" Then
            ' Generate unique filename with timestamp
            fileName = "POP_" & timestamp & "_" & savedCount & "." & fileExt
            filePath = folderPath & fileName
            
            ' Save attachment
            att.SaveAsFile filePath
            savedCount = savedCount + 1
            
            Debug.Print "Saved attachment: " & filePath
        End If
    Next att
    
    Set fso = Nothing
    Exit Sub
    
ErrorHandler:
    Debug.Print "Error saving attachments: " & Err.Description
    If Not fso Is Nothing Then Set fso = Nothing
End Sub

' ========================================
' HELPER: Sanitize folder name (remove invalid characters)
' ========================================
Private Function SanitizeFolderName(folderName As String) As String
    Dim invalidChars As String
    Dim i As Integer
    Dim result As String
    
    invalidChars = "\/:*?""<>|"
    result = folderName
    
    ' Replace invalid characters with underscore
    For i = 1 To Len(invalidChars)
        result = Replace(result, Mid(invalidChars, i, 1), "_")
    Next i
    
    SanitizeFolderName = result
End Function

' ========================================
' HELPER: Create folder path recursively
' ========================================
Private Sub CreateFolderPath(folderPath As String)
    Dim fso As Object
    Dim pathParts() As String
    Dim currentPath As String
    Dim i As Integer
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Remove trailing backslash
    If Right(folderPath, 1) = "\" Then
        folderPath = Left(folderPath, Len(folderPath) - 1)
    End If
    
    ' Split path into parts
    pathParts = Split(folderPath, "\")
    
    ' Build path incrementally
    currentPath = pathParts(0)
    For i = 1 To UBound(pathParts)
        currentPath = currentPath & "\" & pathParts(i)
        If Not fso.FolderExists(currentPath) Then
            fso.CreateFolder currentPath
        End If
    Next i
    
    Set fso = Nothing
End Sub
```

---

### STEP 5: Configure Settings

Update the following constants in the code to match your environment:

```vba
' FNB sender email pattern (adjust based on actual FNB emails)
Private Const FNB_SENDER_EMAIL As String = "@fnb.co.za"

' Root folder name for proof of payments (Outlook folder)
Private Const ROOT_FOLDER_NAME As String = "Proof of Payments"

' File system path for saving attachments (disk folder)
Private Const ATTACHMENTS_ROOT_PATH As String = "C:\ProofOfPayments\"

' Database connection string (update if needed)
Private Const CONN_STRING As String = "Provider=SQLOLEDB;Data Source=ovendelights.database.windows.net;..."
```

---

### STEP 6: Save and Test

1. Click **File** → **Save** in VBA Editor
2. Close VBA Editor
3. Restart Outlook
4. Send a test email with a beneficiary name in the subject
5. Check if folder is created and email is moved

---

## How It Works

### Email Arrival Flow:
```
1. Email arrives in Inbox
   ↓
2. Macro checks if from FNB (or contains "Proof of Payment")
   ↓
3. Searches email subject + body for beneficiary names
   ↓
4. Queries AP_Beneficiaries table for match
   ↓
5. Saves attachments to disk:
   C:\ProofOfPayments\[Beneficiary Name]\POP_20260205_123456_0.pdf
   ↓
6. Creates Outlook folder structure:
   Inbox
     └── Proof of Payments
           └── [Beneficiary Name]
   ↓
7. Moves email to beneficiary folder
```

### Folder Structure Example:

**Outlook Folders:**
```
Inbox
  └── Proof of Payments
        ├── Test Supplier
        ├── ABC Bakery
        ├── XYZ Ingredients
        └── ...
```

**Disk Folders:**
```
C:\ProofOfPayments\
  ├── Test Supplier\
  │     ├── POP_20260205_123456_0.pdf
  │     ├── POP_20260205_143022_0.pdf
  │     └── POP_20260206_091533_0.pdf
  ├── ABC Bakery\
  │     ├── POP_20260205_154411_0.pdf
  │     └── POP_20260207_102345_0.pdf
  └── XYZ Ingredients\
        └── POP_20260205_163028_0.pdf
```

---

## Matching Logic

### Priority Order:
1. **Exact Match**: Beneficiary name appears exactly in email
2. **Longest Match First**: Checks longer names first to avoid partial matches
3. **Case-Insensitive**: "TEST SUPPLIER" matches "Test Supplier"

### Example Matches:
- Email subject: "FNB Proof of Payment - Test Supplier - R1,234.56"
  - ✅ Matches "Test Supplier"
- Email body: "Payment made to ABC BAKERY on 2026-02-05"
  - ✅ Matches "ABC Bakery"

---

## Troubleshooting

### Macro Not Running:
- **Check**: Macro security settings enabled
- **Fix**: File → Options → Trust Center → Enable macros

### No Folders Created:
- **Check**: Database connection string correct
- **Fix**: Test connection in VBA Immediate Window (Ctrl+G):
  ```vba
  Dim conn As Object
  Set conn = CreateObject("ADODB.Connection")
  conn.Open CONN_STRING
  Debug.Print "Connected: " & conn.State
  conn.Close
  ```

### Emails Not Moving:
- **Check**: FNB sender email pattern matches actual emails
- **Fix**: Update `FNB_SENDER_EMAIL` constant
- **Debug**: Check Immediate Window (Ctrl+G) for debug messages

### Beneficiary Not Matched:
- **Check**: Beneficiary name exists in `AP_Beneficiaries` table
- **Check**: Beneficiary name appears in email subject or body
- **Fix**: Verify beneficiary name spelling matches exactly

### Attachments Not Saving:
- **Check**: `ATTACHMENTS_ROOT_PATH` folder exists and is writable
- **Check**: Email has PDF/PNG/JPG attachments
- **Fix**: Create `C:\ProofOfPayments\` folder manually
- **Fix**: Check file permissions on folder
- **Debug**: Check Immediate Window for "Saved attachment:" messages

---

## Advanced Features (Future Enhancements)

### 1. Log to ERP Database
Add code to log proof of payment receipt:
```vba
' Insert into PaymentProofLog table
sql = "INSERT INTO PaymentProofLog (BeneficiaryID, EmailSubject, ReceivedDate, FilePath) " & _
      "VALUES (@BeneficiaryID, @Subject, @Date, @Path)"
```

### 2. Extract Payment Details
Parse email for:
- Payment amount
- Payment date
- Reference number
- Bank account

### 3. Auto-Reconciliation
Match proof of payment to pending invoices in `AP_Invoices` table

### 4. Email Notifications
Send notification to accounts team when proof of payment received

---

## Security Considerations

### Database Credentials:
- ⚠️ Connection string contains database password
- 🔒 VBA code is password-protected in production
- 🔒 Use Windows Authentication if possible

### Macro Security:
- ✅ Only enable macros from trusted sources
- ✅ Code-sign the macro in production
- ✅ Restrict macro permissions to necessary operations only

---

## Maintenance

### Regular Tasks:
1. **Monthly**: Review unmatched emails in Inbox
2. **Quarterly**: Verify folder structure matches active beneficiaries
3. **Yearly**: Update database connection string if credentials change

### When Adding New Beneficiaries:
- ✅ No action needed - macro automatically reads from database
- ✅ Folders created automatically on first email

### When Removing Beneficiaries:
- ⚠️ Manually archive or delete old beneficiary folders
- ⚠️ Set `IsActive = 0` in `AP_Beneficiaries` table

---

## Support

### Debug Mode:
Press **Ctrl+G** in VBA Editor to open Immediate Window and view debug messages.

### Common Debug Messages:
- `"Moved email to folder: [Beneficiary Name]"` - Success
- `"No beneficiary match found for email: [Subject]"` - No match
- `"Error processing email: [Error Description]"` - Error occurred

---

## Implementation Checklist

- [ ] Enable macros in Outlook
- [ ] Add database reference in VBA Editor
- [ ] Paste macro code into ThisOutlookSession
- [ ] Update connection string
- [ ] Update FNB sender email pattern
- [ ] Save and restart Outlook
- [ ] Test with sample email
- [ ] Verify folder creation
- [ ] Verify email moved correctly
- [ ] Document any customizations
- [ ] Train users on folder structure

---

## Status: READY FOR IMPLEMENTATION

**Pending**: User permission to use email for proof of payments

**Next Steps**:
1. Obtain permission to use email for proof of payments
2. Confirm FNB email sender address pattern
3. Test with sample FNB proof of payment emails
4. Deploy to production Outlook
5. Train accounts team on new folder structure

---

**Document Version**: 1.0  
**Created**: 2026-02-05  
**Author**: Cascade AI  
**Status**: Documented - Awaiting Implementation Approval
