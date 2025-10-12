# Administration Module
## User Training Manual - Complete Guide

**Version:** 1.0  
**Last Updated:** October 2025  
**Module:** Administration

---

## Table of Contents

1. [Module Overview](#module-overview)
2. [Menu Structure](#menu-structure)
3. [Dashboard](#dashboard)
4. [User Management](#user-management)
5. [Branch Management](#branch-management)
6. [Audit Log](#audit-log)
7. [System Settings](#system-settings)
8. [Role Access Control](#role-access-control)

---

## Module Overview

### Purpose

The Administration module provides system-wide configuration and management capabilities. This module is restricted to administrators and controls:

- User accounts and permissions
- Branch setup and configuration
- System audit trails
- Security settings
- Role-based access control

### Who Can Access

⚠️ **Access Restricted:** Only users with **Administrator** or **Super Administrator** roles can access this module.

### Key Functions

✅ Create and manage user accounts  
✅ Configure branches and locations  
✅ Monitor system activity through audit logs  
✅ Configure system-wide settings  
✅ Define role permissions  
✅ Ensure system security and compliance

---

## Menu Structure

```
Administration
├── Dashboard
├── User Management
├── Branch Management
├── Audit Log
├── System Settings
└── Role Access Control
```

---

## Dashboard

### Purpose
The Administration Dashboard provides an overview of system health, user activity, and key metrics.

### Accessing the Dashboard

1. Click **Administration** in the top menu
2. Select **Dashboard**
3. Dashboard opens in main workspace

### Dashboard Components

#### System Health Panel

**Displays:**
- **System Status:** Online/Offline
- **Database Status:** Connected/Disconnected
- **Last Backup:** Date and time of last database backup
- **Disk Space:** Available storage space
- **Memory Usage:** Current RAM utilization

**Color Indicators:**
- 🟢 **Green:** System healthy
- 🟡 **Yellow:** Warning - attention needed
- 🔴 **Red:** Critical - immediate action required

#### Active Users Panel

**Shows:**
- Number of users currently logged in
- List of active users with:
  * Username
  * Branch location
  * Login time
  * Current activity
  * IP address

**Actions:**
- Click user to view details
- Force logout if needed (Super Admin only)

#### Recent Activity Panel

**Displays last 50 system activities:**
- User logins/logouts
- Failed login attempts
- Data modifications
- Report generation
- System errors

**Filtering:**
- By date range
- By user
- By activity type
- By severity level

#### System Statistics

**Key Metrics:**
- Total users in system
- Active branches
- Total transactions today
- Database size
- System uptime

#### Quick Actions

**Buttons for common tasks:**
- Create New User
- Add Branch
- View Full Audit Log
- Backup Database
- System Settings

### Using the Dashboard

**Monitoring System Health:**
1. Check System Health panel regularly
2. If yellow/red indicators:
   - Click for details
   - Take corrective action
   - Contact IT if needed

**Reviewing User Activity:**
1. Check Active Users panel
2. Verify expected users are logged in
3. Investigate suspicious activity
4. Force logout inactive sessions

**Analyzing Trends:**
1. Review Recent Activity
2. Look for patterns
3. Identify potential issues
4. Generate detailed reports if needed

---

## User Management

### Purpose
Create, modify, and manage user accounts and their access permissions.

### Accessing User Management

1. Click **Administration** → **User Management**
2. User list appears in grid

### User List View

**Grid Columns:**
- **Username:** Login name
- **Full Name:** User's complete name
- **Role:** Assigned role
- **Branch:** Primary branch
- **Status:** Active/Inactive/Locked
- **Last Login:** Last login date/time
- **Created Date:** Account creation date

**Toolbar Buttons:**
- **New User:** Create new account
- **Edit:** Modify selected user
- **Deactivate:** Disable user account
- **Reset Password:** Force password reset
- **Unlock:** Unlock locked account
- **Refresh:** Reload user list

### Creating a New User

#### Step 1: Open New User Form

1. Click **New User** button
2. New User form opens

#### Step 2: Enter Personal Information

**Required Fields:**
- **Username:** Unique login name
  * 3-20 characters
  * Letters, numbers, underscore only
  * No spaces
  * Case-sensitive
  * Example: jsmith, m.jones

- **Full Name:** User's complete name
  * First name and surname
  * Example: John Smith

- **Email Address:** Valid email
  * Used for password resets
  * System notifications
  * Must be unique

- **Mobile Number:** Contact number
  * Format: 0XX-XXX-XXXX
  * Used for SMS notifications

**Optional Fields:**
- **Employee Number:** If applicable
- **Department:** User's department
- **Job Title:** Position
- **Manager:** Reporting manager

#### Step 3: Set Initial Password

**Two Options:**

*Option A: Set Temporary Password*
1. Enter temporary password
2. Check "Must change password on first login"
3. User will be forced to change on first login

*Option B: Send Password Reset Email*
1. Check "Send password reset email"
2. System generates secure link
3. User sets own password via email

**Password Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character (!@#$%^&*)
- Cannot contain username
- Cannot reuse last 5 passwords

#### Step 4: Assign Role

**Select Role from Dropdown:**

1. **Super Administrator**
   - Full system access
   - Can create administrators
   - Can modify system settings
   - ⚠️ Use sparingly - highest privilege

2. **Administrator**
   - Full access except system settings
   - Can manage users and branches
   - Cannot create other administrators

3. **Branch Manager**
   - Full access to assigned branch
   - Can approve transactions
   - Can view branch reports
   - Cannot access other branches

4. **Accountant**
   - Full accounting module access
   - Can view all financial reports
   - Can process payments
   - Read-only access to other modules

5. **Stockroom Manager**
   - Full stockroom access
   - Can approve purchase orders
   - Can manage suppliers
   - Limited retail access

6. **Production Manager**
   - Full manufacturing access
   - Can create production orders
   - Can manage BOMs
   - Can view stockroom inventory

7. **Cashier**
   - POS access only
   - Can process sales
   - Can handle returns
   - No access to reports or settings

8. **Stockroom Clerk**
   - Stockroom data entry
   - Can receive goods
   - Can create requisitions
   - Cannot approve purchases

💡 **Tip:** Choose the role with minimum required permissions (Principle of Least Privilege)

#### Step 5: Assign Branch

**Primary Branch:**
- Select user's main working branch
- User will default to this branch on login
- Required field

**Additional Branches (if applicable):**
- Check boxes for other branches user can access
- Multi-branch users can switch between branches
- Leave unchecked for single-branch users

#### Step 6: Set Account Status

**Status Options:**
- **Active:** User can log in (default for new users)
- **Inactive:** User cannot log in, account preserved
- **Locked:** Temporarily locked (usually after failed logins)

**Account Expiry (optional):**
- Set expiry date for temporary accounts
- Leave blank for permanent accounts
- System automatically deactivates on expiry date

#### Step 7: Configure Additional Settings

**Login Settings:**
- **Allow Remote Login:** Can user log in from outside network?
- **Require Two-Factor Authentication:** Extra security layer
- **Session Timeout:** Minutes of inactivity before auto-logout (default: 30)

**Notification Preferences:**
- **Email Notifications:** Receive system emails
- **SMS Notifications:** Receive SMS alerts
- **Daily Summary:** Daily activity report

**Working Hours:**
- **Start Time:** When user typically starts work
- **End Time:** When user typically ends work
- **Time Zone:** User's time zone

#### Step 8: Review and Save

1. Review all entered information
2. Verify role and permissions are correct
3. Click **Save**
4. Confirmation message appears
5. User account created

**Post-Creation Actions:**
- User receives welcome email (if email notifications enabled)
- Temporary password sent (if applicable)
- User appears in user list
- Audit log entry created

### Editing an Existing User

#### Step 1: Select User

1. In User Management grid, find the user
2. Use search box if needed
3. Double-click user row, or
4. Select user and click **Edit** button

#### Step 2: Modify Information

**Can Change:**
- Full name
- Email address
- Mobile number
- Role (with proper authorization)
- Branch assignment
- Status
- Settings and preferences

**Cannot Change:**
- Username (permanent)
- Creation date
- Created by

#### Step 3: Save Changes

1. Make necessary changes
2. Click **Save**
3. Confirmation prompt appears
4. Confirm changes
5. Audit log entry created

⚠️ **Important:** Changing a user's role takes effect immediately. If user is currently logged in, they may need to log out and back in for changes to fully apply.

### Resetting User Password

#### When to Reset:
- User forgot password
- Password compromised
- Security policy requires change
- Account locked due to failed attempts

#### Reset Process:

**Step 1: Select User**
1. Find user in list
2. Select user row

**Step 2: Initiate Reset**
1. Click **Reset Password** button
2. Reset options dialog appears

**Step 3: Choose Reset Method**

*Method A: Set Temporary Password*
1. Select "Set temporary password"
2. Enter temporary password
3. Check "User must change on next login"
4. Click **OK**
5. Communicate password to user securely

*Method B: Email Reset Link*
1. Select "Send password reset email"
2. Click **OK**
3. User receives email with secure link
4. Link valid for 24 hours
5. User sets own password

*Method C: SMS Reset Code*
1. Select "Send SMS reset code"
2. Click **OK**
3. User receives 6-digit code via SMS
4. User enters code on login screen
5. User sets new password

**Step 4: Verify Reset**
1. User attempts login
2. If temporary password: forced to change
3. If email/SMS: follows reset process
4. Confirm user can log in successfully

### Unlocking User Account

**Accounts Lock When:**
- 5 consecutive failed login attempts
- Administrator manually locks account
- Suspicious activity detected

**Unlock Process:**

1. Select locked user in list
2. Click **Unlock** button
3. Review lock reason
4. Verify user identity before unlocking
5. Click **Confirm Unlock**
6. Account immediately unlocked
7. User can attempt login again
8. Failed attempt counter reset to zero

💡 **Best Practice:** Investigate why account was locked before unlocking. If suspicious activity, change password before unlocking.

### Deactivating User Account

**When to Deactivate:**
- Employee resignation/termination
- Extended leave of absence
- Role change requiring new account
- Security concerns

**Deactivation Process:**

**Step 1: Select User**
1. Find user in list
2. Select user row

**Step 2: Deactivate**
1. Click **Deactivate** button
2. Deactivation dialog appears

**Step 3: Enter Reason**
1. Select reason from dropdown:
   - Resignation
   - Termination
   - Leave of Absence
   - Security Issue
   - Other (specify)
2. Enter additional notes
3. Set effective date (default: immediate)

**Step 4: Handle Active Sessions**
If user currently logged in:
1. System shows warning
2. Choose action:
   - Force immediate logout
   - Allow to complete current work
   - Schedule deactivation for later

**Step 5: Confirm Deactivation**
1. Review summary
2. Click **Confirm**
3. Account deactivated
4. User cannot log in
5. Audit log entry created

**Effects of Deactivation:**
- User cannot log in
- Active sessions terminated
- Email notifications stopped
- Account data preserved
- Can be reactivated later if needed

### Reactivating User Account

**To Reactivate:**
1. Filter list to show "Inactive" users
2. Select deactivated user
3. Click **Reactivate** button
4. Enter reason for reactivation
5. Verify user details still current
6. Update information if needed
7. Click **Confirm**
8. User can log in again

### User Activity Report

**View User Activity:**
1. Select user in list
2. Click **Activity Report** button
3. Report shows:
   - Login history
   - Transactions performed
   - Reports generated
   - Data modifications
   - Failed login attempts

**Filter Options:**
- Date range
- Activity type
- Branch
- Success/failure

**Export Options:**
- PDF
- Excel
- CSV

### Bulk User Operations

**Import Users from File:**
1. Click **Import Users** button
2. Download template file
3. Fill in user details in Excel
4. Upload completed file
5. System validates data
6. Review validation results
7. Confirm import
8. Users created in batch

**Export User List:**
1. Set filters if needed
2. Click **Export** button
3. Select format (Excel/CSV/PDF)
4. Choose fields to include
5. Click **Export**
6. File downloads

**Bulk Password Reset:**
1. Select multiple users (Ctrl+Click)
2. Click **Bulk Actions** → **Reset Passwords**
3. Choose reset method
4. Confirm action
5. All selected users' passwords reset

### User Management Best Practices

✅ **DO:**
- Review user list monthly
- Deactivate accounts promptly when users leave
- Use strong, unique passwords
- Assign minimum required permissions
- Document role changes
- Regular security audits
- Enable two-factor authentication for sensitive roles

❌ **DON'T:**
- Share administrator accounts
- Use generic usernames (e.g., "admin", "user1")
- Give everyone administrator access
- Leave inactive accounts active
- Reuse passwords
- Skip password requirements
- Ignore failed login alerts

---

## Branch Management

### Purpose
Configure and manage business locations/branches in the system.

### Accessing Branch Management

1. Click **Administration** → **Branch Management**
2. Branch list appears

### Branch List View

**Grid Columns:**
- **Branch Code:** Unique identifier (e.g., JHB001)
- **Branch Name:** Full branch name
- **Location:** City/area
- **Status:** Active/Inactive
- **Manager:** Branch manager name
- **Phone:** Contact number
- **Created Date:** When branch added

**Toolbar:**
- **New Branch:** Add new branch
- **Edit:** Modify branch details
- **Deactivate:** Close branch
- **View Details:** Full branch information
- **Refresh:** Reload list

### Creating a New Branch

#### Step 1: Open New Branch Form

1. Click **New Branch** button
2. Branch details form opens

#### Step 2: Enter Branch Information

**Basic Information:**

- **Branch Code:** (Required)
  * Unique 3-6 character code
  * Usually location abbreviation + number
  * Example: JHB001, CPT002, DBN001
  * Cannot be changed after creation

- **Branch Name:** (Required)
  * Full descriptive name
  * Example: "Johannesburg Main Branch"
  * Example: "Cape Town Waterfront"

- **Trading Name:** (Optional)
  * Name used for customer-facing documents
  * May differ from official branch name

**Location Details:**

- **Physical Address:**
  * Street address
  * Suburb
  * City
  * Province
  * Postal code
  * Country

- **Postal Address:** (if different)
  * Can copy from physical address
  * Or enter separate postal address

- **GPS Coordinates:** (Optional)
  * Latitude
  * Longitude
  * Used for delivery routing

**Contact Information:**

- **Phone Number:** (Required)
  * Main branch phone
  * Format: (0XX) XXX-XXXX

- **Fax Number:** (Optional)
  * If branch has fax

- **Email Address:** (Required)
  * Branch email
  * Example: jhb001@ovendelights.co.za

- **Website:** (Optional)
  * Branch-specific website if applicable

#### Step 3: Assign Branch Manager

- **Branch Manager:** (Required)
  * Select from user list
  * Must have Branch Manager role
  * Responsible for branch operations

- **Assistant Manager:** (Optional)
  * Backup manager
  * Can approve in manager's absence

#### Step 4: Configure Operating Hours

**Standard Hours:**
- **Monday - Friday:**
  * Opening time
  * Closing time
- **Saturday:**
  * Opening time
  * Closing time
- **Sunday:**
  * Opening time
  * Closing time
  * Or mark as "Closed"

**Public Holidays:**
- Select holiday schedule
- Or mark as "Closed on public holidays"

**Special Hours:**
- Add exceptions for specific dates
- Example: Extended hours during December

#### Step 5: Set Financial Configuration

**Bank Details:**
- **Bank Name:**
- **Branch Code:**
- **Account Number:**
- **Account Type:** Cheque/Savings

**Tax Information:**
- **VAT Number:** Branch VAT registration
- **Tax Office:** SARS office branch reports to
- **Income Tax Number:** If separate from company

**Document Numbering:**
- **Invoice Prefix:** Example: JHB-INV-
- **Receipt Prefix:** Example: JHB-RCT-
- **Starting Number:** Usually 00001

#### Step 6: Configure Inventory Settings

**Stock Management:**
- **Enable Stock Control:** Yes/No
- **Reorder Notifications:** Email/SMS/Both
- **Low Stock Threshold:** Percentage (default: 20%)

**Pricing:**
- **Price Level:** Standard/Wholesale/Retail
- **Allow Price Override:** Yes/No
- **Discount Authority Level:** Manager/Cashier

**Stock Transfer:**
- **Allow Inter-Branch Transfers:** Yes/No
- **Require Approval:** Yes/No
- **Approval Limit:** Amount requiring approval

#### Step 7: Set System Preferences

**Receipt Printing:**
- **Receipt Header:** Text at top of receipt
- **Receipt Footer:** Text at bottom
- **Logo:** Upload branch logo
- **Printer Name:** Default receipt printer

**Reporting:**
- **Report Currency:** ZAR (default)
- **Date Format:** DD/MM/YYYY or MM/DD/YYYY
- **Number Format:** 1,000.00 or 1.000,00

**Security:**
- **Require Manager Approval For:**
  * Voids over R500
  * Discounts over 10%
  * Returns over R1000
  * Price overrides

#### Step 8: Review and Save

1. Review all entered information
2. Verify all required fields completed
3. Click **Save**
4. Confirmation message
5. Branch created and active

**Post-Creation:**
- Branch appears in branch list
- Available in branch dropdowns throughout system
- Users can be assigned to branch
- Inventory can be allocated
- Transactions can be processed

### Editing Branch Details

**To Edit:**
1. Select branch in list
2. Click **Edit** button
3. Modify information
4. Click **Save**

**Can Change:**
- Contact details
- Operating hours
- Manager assignment
- Settings and preferences

**Cannot Change:**
- Branch code (permanent identifier)
- Creation date

### Deactivating a Branch

**When to Deactivate:**
- Branch permanently closed
- Temporary closure (renovations, etc.)
- Consolidation with another branch

**Deactivation Process:**

**Step 1: Prepare for Closure**
1. Transfer remaining stock to other branches
2. Complete all pending transactions
3. Process final reports
4. Archive important documents

**Step 2: Select Branch**
1. Find branch in list
2. Select branch row

**Step 3: Deactivate**
1. Click **Deactivate** button
2. Deactivation wizard opens

**Step 4: Handle Stock**
Choose option:
- Transfer all stock to another branch
- Write off remaining stock
- Keep stock for reactivation

**Step 5: Handle Users**
For users assigned to this branch:
- Reassign to another branch
- Deactivate user accounts
- Leave for manual handling

**Step 6: Set Effective Date**
- Immediate closure
- Or schedule future date

**Step 7: Enter Closure Reason**
- Permanent closure
- Temporary closure
- Consolidation
- Other (specify)

**Step 8: Confirm Deactivation**
1. Review summary
2. Click **Confirm**
3. Branch deactivated
4. Users notified
5. Audit log entry created

**Effects:**
- Branch marked inactive
- Cannot process new transactions
- Historical data preserved
- Reports still accessible
- Can be reactivated if needed

### Branch Performance Dashboard

**Access:**
1. Select branch in list
2. Click **Performance Dashboard**

**Dashboard Shows:**
- Sales performance
- Inventory turnover
- Customer count
- Staff productivity
- Profitability metrics

**Time Periods:**
- Today
- This Week
- This Month
- This Year
- Custom range

**Comparisons:**
- vs. Previous period
- vs. Same period last year
- vs. Other branches
- vs. Budget/targets

### Inter-Branch Configuration

**Setup Inter-Branch Transfers:**
1. Click **Inter-Branch Settings**
2. Configure:
   - Which branches can transfer to each other
   - Approval requirements
   - Transfer pricing rules
   - Transit time estimates

**Transfer Pricing:**
- Cost price
- Standard price
- Custom pricing matrix

### Branch Reports

**Available Reports:**
- Branch Performance Summary
- Sales by Branch
- Inventory by Branch
- Staff by Branch
- Customer by Branch
- Profitability by Branch

**Generate Report:**
1. Select report type
2. Choose branches (one, multiple, or all)
3. Set date range
4. Click **Generate**
5. View/Print/Export

---

## Audit Log

### Purpose
Track all system activities for security, compliance, and troubleshooting.

### Accessing Audit Log

1. Click **Administration** → **Audit Log**
2. Audit log viewer opens

### Audit Log View

**Grid Columns:**
- **Timestamp:** Date and time of activity
- **User:** Who performed the action
- **Module:** Which part of system
- **Action:** What was done
- **Entity:** What was affected
- **Details:** Additional information
- **IP Address:** Where action originated
- **Status:** Success/Failed

### What Gets Logged

**User Activities:**
- Login attempts (successful and failed)
- Logout events
- Password changes
- Permission changes
- Account lockouts

**Data Modifications:**
- Record creation
- Record updates
- Record deletion
- Bulk operations
- Import/export activities

**Financial Transactions:**
- Sales processed
- Payments received
- Invoices created
- Refunds issued
- Adjustments made

**System Events:**
- System startup/shutdown
- Database backups
- Configuration changes
- Error occurrences
- Security alerts

**Administrative Actions:**
- User account changes
- Role modifications
- Branch updates
- System setting changes
- Report generation

### Searching the Audit Log

**Quick Search:**
1. Enter search term in search box
2. Press Enter
3. Results filtered instantly

**Advanced Search:**
1. Click **Advanced Search** button
2. Set multiple criteria:

**Filter by Date:**
- Today
- Yesterday
- Last 7 days
- Last 30 days
- Custom date range

**Filter by User:**
- Select specific user
- Or "All Users"

**Filter by Module:**
- Administration
- Accounting
- Stockroom
- Manufacturing
- Retail
- Reporting

**Filter by Action Type:**
- Create
- Update
- Delete
- Login
- Logout
- View
- Print
- Export

**Filter by Status:**
- Success
- Failed
- Warning
- Error

**Filter by Entity:**
- Users
- Branches
- Products
- Customers
- Suppliers
- Transactions

3. Click **Apply Filters**
4. Results update

### Viewing Entry Details

**To See Full Details:**
1. Double-click any audit log entry
2. Detail view opens showing:
   - Complete timestamp
   - User information
   - Action description
   - Before/after values (for updates)
   - Related records
   - Error messages (if failed)
   - Session information

**Before/After Comparison:**
For update actions:
- Shows old value
- Shows new value
- Highlights changes
- Useful for tracking modifications

### Exporting Audit Log

**Export for Compliance:**
1. Set desired filters
2. Click **Export** button
3. Choose format:
   - Excel (.xlsx)
   - CSV (.csv)
   - PDF (formatted report)
   - XML (for other systems)

4. Select fields to include
5. Click **Export**
6. File downloads

**Scheduled Exports:**
1. Click **Schedule Export**
2. Set:
   - Frequency (Daily/Weekly/Monthly)
   - Time
   - Format
   - Email recipients
3. System automatically exports and emails

### Audit Log Reports

**Pre-Built Reports:**

1. **User Activity Report**
   - All actions by specific user
   - Time period
   - Success/failure rate

2. **Failed Login Report**
   - All failed login attempts
   - Potential security threats
   - Locked accounts

3. **Data Modification Report**
   - All creates/updates/deletes
   - By module
   - By user
   - By date

4. **System Error Report**
   - All system errors
   - Error frequency
   - Affected modules

5. **Compliance Report**
   - Activities requiring audit trail
   - Financial transactions
   - User access changes
   - Formatted for auditors

**Generate Report:**
1. Select report type
2. Set parameters
3. Click **Generate**
4. View/Print/Export

### Audit Log Retention

**Retention Policy:**
- Audit logs kept for 7 years (default)
- Cannot be deleted before retention period
- Archived after retention period
- Archives stored securely

**Storage Management:**
- System monitors log size
- Alerts when approaching limits
- Automatic archiving of old logs
- Compressed archives save space

### Security and Compliance

**Audit Log Security:**
- ✅ Cannot be modified or deleted by users
- ✅ Only administrators can view
- ✅ All access to audit log is itself logged
- ✅ Tamper-proof design
- ✅ Encrypted storage

**Compliance Standards:**
- Meets POPIA requirements
- Supports SARS audits
- Financial audit trail
- ISO 27001 compatible

### Investigating Issues

**Using Audit Log for Troubleshooting:**

**Scenario 1: User Reports Missing Data**
1. Search audit log for that user
2. Filter by "Delete" actions
3. Check if user accidentally deleted
4. Or check if system error occurred
5. Restore from backup if needed

**Scenario 2: Unauthorized Access Suspected**
1. Search for user's activity
2. Check login times and locations
3. Review actions performed
4. Look for suspicious patterns
5. Take security action if needed

**Scenario 3: System Error Occurred**
1. Filter by "Error" status
2. Check timestamp of error
3. View error details
4. Identify affected module
5. Report to IT with log details

**Scenario 4: Financial Discrepancy**
1. Search for transaction ID
2. View complete transaction history
3. Check who processed
4. Review all modifications
5. Identify where discrepancy occurred

### Audit Log Best Practices

✅ **DO:**
- Review audit log regularly
- Investigate failed login attempts
- Monitor administrative actions
- Export logs for compliance
- Keep logs for required period
- Use for troubleshooting

❌ **DON'T:**
- Ignore security alerts
- Disable audit logging
- Delete audit records
- Share audit log access
- Overlook patterns of suspicious activity

---

## System Settings

### Purpose
Configure system-wide parameters and preferences.

### Accessing System Settings

1. Click **Administration** → **System Settings**
2. Settings panel opens with tabs

### Settings Categories

```
System Settings
├── General
├── Security
├── Email
├── Notifications
├── Backup
├── Integration
└── Advanced
```

### General Settings Tab

#### Company Information

**Company Details:**
- **Company Name:** Legal entity name
- **Trading Name:** DBA name if different
- **Registration Number:** Company registration
- **VAT Number:** VAT registration number
- **Tax Reference:** SARS tax reference
- **Physical Address:** Head office address
- **Postal Address:** Mailing address
- **Phone Number:** Main contact number
- **Email Address:** General inquiries email
- **Website:** Company website URL

**Logo and Branding:**
- **Company Logo:** Upload logo image
  * Recommended size: 300x100 pixels
  * Format: PNG with transparent background
  * Used on reports, invoices, receipts

- **Color Scheme:** Primary brand color
  * Used in system interface
  * Used in customer-facing documents

#### Regional Settings

**Locale:**
- **Country:** South Africa (default)
- **Language:** English (default)
- **Currency:** ZAR - South African Rand
- **Currency Symbol:** R
- **Currency Format:** R 1,234.56

**Date and Time:**
- **Date Format:** DD/MM/YYYY or MM/DD/YYYY
- **Time Format:** 24-hour or 12-hour
- **Time Zone:** Africa/Johannesburg
- **First Day of Week:** Monday or Sunday

**Number Formats:**
- **Decimal Separator:** . or ,
- **Thousands Separator:** , or space
- **Decimal Places:** 2 (default for currency)

#### Financial Year

**Financial Year Settings:**
- **Year End Month:** February (typical for SA)
- **Year End Day:** Last day of month
- **Current Financial Year:** 2025
- **Lock Previous Years:** Yes/No
  * If Yes, prevents changes to closed years

**Period Management:**
- **Accounting Periods:** Monthly/Quarterly
- **Current Period:** Auto-calculated
- **Period Lock:** Lock periods after month-end

### Security Settings Tab

#### Password Policy

**Password Requirements:**
- **Minimum Length:** 8-20 characters (default: 8)
- **Require Uppercase:** Yes/No
- **Require Lowercase:** Yes/No
- **Require Numbers:** Yes/No
- **Require Special Characters:** Yes/No
- **Password Expiry:** Days (0 = never, default: 90)
- **Password History:** Number of previous passwords to remember (default: 5)
- **Prevent Common Passwords:** Yes/No

#### Login Security

**Login Restrictions:**
- **Max Failed Attempts:** Before account locks (default: 5)
- **Lockout Duration:** Minutes (default: 30)
- **Session Timeout:** Minutes of inactivity (default: 30)
- **Concurrent Logins:** Allow same user multiple sessions? (default: No)
- **IP Restrictions:** Whitelist specific IP addresses (optional)

**Two-Factor Authentication:**
- **Enable 2FA:** Yes/No
- **2FA Method:** SMS/Email/Authenticator App
- **Require for Roles:** Select which roles must use 2FA
- **Grace Period:** Days before 2FA mandatory (default: 7)

#### Data Security

**Encryption:**
- **Encrypt Database:** Yes/No (recommended: Yes)
- **Encrypt Backups:** Yes/No (recommended: Yes)
- **Encrypt Sensitive Fields:** Credit cards, passwords, etc.

**Data Privacy:**
- **POPIA Compliance Mode:** Enabled
- **Data Retention Period:** Years (default: 7)
- **Automatic Data Purging:** Yes/No
- **Audit Log Retention:** Years (default: 7)

### Email Settings Tab

#### SMTP Configuration

**Outgoing Mail Server:**
- **SMTP Server:** smtp.example.com
- **SMTP Port:** 587 (TLS) or 465 (SSL)
- **Use SSL/TLS:** Yes (recommended)
- **Authentication Required:** Yes
- **Username:** email@ovendelights.co.za
- **Password:** ••••••••
- **From Name:** Oven Delights ERP
- **From Email:** noreply@ovendelights.co.za

**Test Connection:**
1. Enter settings
2. Click **Test Connection**
3. System sends test email
4. Verify receipt
5. Save if successful

#### Email Templates

**System Email Templates:**
- Welcome Email (new users)
- Password Reset
- Account Locked
- Invoice Email
- Receipt Email
- Statement Email
- Report Email

**Customize Templates:**
1. Select template
2. Click **Edit**
3. Modify:
   - Subject line
   - Body text
   - Variables (e.g., {UserName}, {InvoiceNumber})
   - Formatting
4. Preview
5. Save

**Template Variables:**
- {CompanyName}
- {UserName}
- {UserEmail}
- {BranchName}
- {InvoiceNumber}
- {Amount}
- {Date}
- {Time}

### Notifications Settings Tab

#### Email Notifications

**System Notifications:**
- [ ] User Login Alerts
- [ ] Failed Login Attempts
- [ ] System Errors
- [ ] Database Backup Status
- [ ] Low Stock Alerts
- [ ] Overdue Payments
- [ ] Report Generation Complete

**Recipients:**
- Add email addresses for each notification type
- Can have multiple recipients
- Separate by comma or semicolon

#### SMS Notifications

**SMS Configuration:**
- **SMS Provider:** Select provider
- **API Key:** Provider API key
- **Sender ID:** Company name (max 11 chars)

**SMS Alerts:**
- [ ] Critical System Errors
- [ ] Security Alerts
- [ ] Payment Confirmations
- [ ] Delivery Notifications

**SMS Recipients:**
- Add mobile numbers
- Format: 27XXXXXXXXX (international format)

#### In-App Notifications

**Notification Types:**
- [ ] Show desktop notifications
- [ ] Play sound for alerts
- [ ] Show notification badge
- [ ] Email digest (daily summary)

**Notification Preferences by Role:**
- Configure which roles receive which notifications
- Prevent notification overload

### Backup Settings Tab

#### Automatic Backups

**Backup Schedule:**
- **Frequency:** Daily/Weekly/Monthly
- **Time:** When to run (e.g., 2:00 AM)
- **Days:** Which days (for weekly)
- **Retention:** How many backups to keep

**Backup Location:**
- **Primary:** Local server path
- **Secondary:** Network location (recommended)
- **Cloud:** Cloud storage (optional)
  * Azure Blob Storage
  * AWS S3
  * Google Cloud Storage

**Backup Options:**
- [ ] Full backup (complete database)
- [ ] Differential backup (changes only)
- [ ] Include file attachments
- [ ] Compress backups
- [ ] Encrypt backups

#### Manual Backup

**Create Backup Now:**
1. Click **Backup Now** button
2. Select backup type:
   - Full
   - Differential
3. Choose location
4. Click **Start Backup**
5. Progress bar shows status
6. Confirmation when complete

**Backup Verification:**
- System automatically verifies backups
- Test restore monthly (recommended)
- Keep backup logs

#### Restore from Backup

⚠️ **Critical Operation - Super Administrator Only**

**Restore Process:**
1. Click **Restore** button
2. Select backup file
3. Choose restore point
4. **Warning:** This will overwrite current data
5. Confirm restore
6. System restores database
7. All users logged out
8. System restarts
9. Verify data integrity

**Before Restoring:**
- Create current backup first
- Notify all users
- Schedule during off-hours
- Have IT support available

### Integration Settings Tab

#### Third-Party Integrations

**Accounting Software:**
- [ ] Enable Pastel Integration
- [ ] Enable Sage Integration
- [ ] Enable QuickBooks Integration

**Payment Gateways:**
- [ ] Enable Card Payments
  * Provider: PayGate/PayFast/Yoco
  * Merchant ID
  * API Key
- [ ] Enable EFT Payments
- [ ] Enable SnapScan
- [ ] Enable Zapper

**Delivery Services:**
- [ ] Enable Courier Integration
  * Courier company
  * Account number
  * API credentials

**Banking:**
- [ ] Enable Bank Feed
  * Bank name
  * Account number
  * API credentials
- [ ] Enable Payment Batching

#### API Settings

**API Access:**
- [ ] Enable REST API
- **API Base URL:** https://api.ovendelights.co.za
- **API Version:** v1
- **Rate Limiting:** Requests per minute

**API Keys:**
- Generate API keys for external applications
- Set permissions per key
- Monitor API usage
- Revoke keys if compromised

### Advanced Settings Tab

⚠️ **Warning:** Advanced settings should only be modified by experienced administrators or IT professionals.

#### Database Settings

**Connection:**
- **Server:** Database server address
- **Database Name:** OvenDelightsERP
- **Authentication:** Windows/SQL Server
- **Connection Timeout:** Seconds (default: 30)
- **Command Timeout:** Seconds (default: 300)

**Performance:**
- **Connection Pooling:** Enabled
- **Max Pool Size:** 100
- **Query Timeout:** Seconds
- **Enable Query Caching:** Yes/No

#### System Performance

**Caching:**
- **Enable Caching:** Yes/No
- **Cache Duration:** Minutes
- **Cache Size:** MB

**Logging:**
- **Log Level:** Error/Warning/Info/Debug
- **Log Location:** File path
- **Max Log Size:** MB
- **Log Retention:** Days

#### Maintenance Mode

**Enable Maintenance Mode:**
1. Check "Enable Maintenance Mode"
2. Enter maintenance message
3. Set allowed IP addresses (admins can still access)
4. Click **Save**
5. All other users see maintenance message

**Use Cases:**
- System upgrades
- Database maintenance
- Major configuration changes
- Emergency fixes

### Saving Settings

**To Save Changes:**
1. Modify settings as needed
2. Click **Save** button at bottom
3. Confirmation prompt appears
4. Click **Yes** to confirm
5. Settings applied immediately
6. Some settings may require system restart

**Settings Validation:**
- System validates all settings before saving
- Invalid settings highlighted in red
- Error messages explain issues
- Fix errors before saving

### Restoring Default Settings

**Reset to Defaults:**
1. Click **Restore Defaults** button
2. Select which categories to reset:
   - All settings
   - Specific tab only
3. **Warning:** This cannot be undone
4. Confirm reset
5. Settings restored to factory defaults

💡 **Tip:** Export current settings before resetting, in case you need to restore them.

### Exporting/Importing Settings

**Export Settings:**
1. Click **Export Settings**
2. Select categories to export
3. Choose file location
4. Click **Export**
5. Settings saved to XML file

**Import Settings:**
1. Click **Import Settings**
2. Select settings file
3. Review settings to import
4. Choose merge or replace
5. Click **Import**
6. Settings applied

**Use Cases:**
- Backup settings before changes
- Copy settings to another installation
- Standardize settings across branches

---

## Role Access Control

### Purpose
Define granular permissions for each user role in the system.

### Accessing Role Access Control

1. Click **Administration** → **Role Access Control**
2. Role management screen opens

⚠️ **Access:** Super Administrator only

### Understanding Roles

**What is a Role?**
- A role is a collection of permissions
- Users are assigned to roles
- Roles determine what users can access and do
- One user can have only one role

**Permission Levels:**
- **None:** Cannot access
- **Read:** View only
- **Write:** View and modify
- **Delete:** View, modify, and delete
- **Full:** All permissions including special functions

### Role List View

**Grid Shows:**
- **Role Name:** Name of role
- **Description:** What the role is for
- **User Count:** How many users have this role
- **Module Access:** Which modules role can access
- **Created Date:** When role was created
- **Modified Date:** Last modification

**Toolbar:**
- **New Role:** Create custom role
- **Edit:** Modify role permissions
- **Copy:** Duplicate role as starting point
- **Delete:** Remove role (if no users assigned)
- **Refresh:** Reload role list

### Pre-Defined Roles

**System comes with standard roles:**

1. **Super Administrator**
   - Full system access
   - Cannot be modified or deleted
   - Can create other administrators

2. **Administrator**
   - Full access except system settings
   - Can manage users and branches

3. **Branch Manager**
   - Full branch access
   - Approval authority
   - Branch reporting

4. **Accountant**
   - Full accounting access
   - Financial reporting
   - Read-only other modules

5. **Stockroom Manager**
   - Full stockroom access
   - Purchase approval
   - Supplier management

6. **Production Manager**
   - Full manufacturing access
   - Production planning
   - Quality control

7. **Cashier**
   - POS only
   - Basic customer service
   - No reporting

8. **Stockroom Clerk**
   - Data entry only
   - No approval authority
   - Limited access

### Creating a Custom Role

#### Step 1: Open New Role Form

1. Click **New Role** button
2. Role configuration form opens

#### Step 2: Enter Role Details

**Basic Information:**
- **Role Name:** Descriptive name (e.g., "Sales Supervisor")
- **Description:** What this role is for
- **Based On:** Copy permissions from existing role (optional)

#### Step 3: Configure Module Access

**For Each Module, Set Access Level:**

**Administration Module:**
- View Users: None/Read/Write
- Create Users: Yes/No
- Modify Users: Yes/No
- Delete Users: Yes/No
- View Audit Log: Yes/No
- Modify System Settings: Yes/No

**Accounting Module:**
- View Transactions: None/Read/Write
- Create Transactions: Yes/No
- Post Journals: Yes/No
- Void Transactions: Yes/No
- View Reports: Yes/No
- Approve Payments: Yes/No
- Reconcile Accounts: Yes/No

**Stockroom Module:**
- View Inventory: None/Read/Write
- Create Purchase Orders: Yes/No
- Approve Purchase Orders: Yes/No (set approval limit)
- Receive Goods: Yes/No
- Manage Suppliers: Yes/No
- Stock Adjustments: Yes/No (set approval limit)

**Manufacturing Module:**
- View Production Orders: None/Read/Write
- Create Production Orders: Yes/No
- Issue Materials: Yes/No
- Complete Builds: Yes/No
- Manage BOMs: Yes/No
- Quality Control: Yes/No

**Retail Module:**
- Process Sales: Yes/No
- Process Returns: Yes/No (set approval limit)
- Apply Discounts: Yes/No (set max discount %)
- Price Override: Yes/No
- Void Sales: Yes/No (set approval limit)
- Manage Customers: None/Read/Write
- View Sales Reports: Yes/No

**Reporting Module:**
- View Reports: Yes/No
- Export Reports: Yes/No
- Schedule Reports: Yes/No
- Create Custom Reports: Yes/No

#### Step 4: Set Approval Limits

**Financial Limits:**
- **Purchase Orders:** Max amount can approve
- **Discounts:** Max percentage can give
- **Refunds:** Max amount can process
- **Voids:** Max amount can void
- **Adjustments:** Max amount can adjust

**Example:**
- Cashier: R0 (no approval authority)
- Supervisor: R1,000
- Manager: R10,000
- Director: Unlimited

#### Step 5: Configure Special Permissions

**Special Functions:**
- [ ] Can access other branches
- [ ] Can view all users' data
- [ ] Can override system warnings
- [ ] Can force-close periods
- [ ] Can modify locked transactions
- [ ] Can delete audit log entries (Super Admin only)
- [ ] Can modify role permissions

#### Step 6: Set Restrictions

**Time Restrictions:**
- Restrict login to specific hours
- Example: Cashiers only during business hours

**IP Restrictions:**
- Restrict to specific IP addresses
- Example: Accountants only from office network

**Branch Restrictions:**
- Limit to specific branches
- Or allow all branches

#### Step 7: Review and Save

1. Review all permissions
2. Verify approval limits
3. Click **Save**
4. Role created
5. Can now assign users to this role

### Editing Role Permissions

**To Modify Role:**
1. Select role in list
2. Click **Edit** button
3. Modify permissions
4. Click **Save**
5. Changes apply immediately to all users with this role

⚠️ **Warning:** Changes affect all users assigned to this role. Users currently logged in may need to log out and back in for changes to take full effect.

### Copying a Role

**To Create Similar Role:**
1. Select existing role
2. Click **Copy** button
3. Enter new role name
4. Permissions copied from original
5. Modify as needed
6. Save new role

💡 **Tip:** Copying is faster than creating from scratch when roles are similar.

### Deleting a Role

**To Delete Role:**
1. Select role in list
2. Click **Delete** button
3. System checks if users assigned
4. If users exist:
   - Cannot delete
   - Must reassign users first
5. If no users:
   - Confirm deletion
   - Role removed

**Cannot Delete:**
- Super Administrator role
- Administrator role
- Roles with assigned users

### Role Assignment Matrix

**View Who Has What Access:**
1. Click **Access Matrix** button
2. Matrix shows:
   - Rows: Users
   - Columns: Modules/Functions
   - Cells: Access level

**Filter Matrix:**
- By branch
- By role
- By module
- By user

**Export Matrix:**
- For documentation
- For audit purposes
- For compliance

### Testing Role Permissions

**Test Before Assigning:**
1. Create test user account
2. Assign new role
3. Log in as test user
4. Verify permissions work as expected
5. Check all modules
6. Test approval limits
7. Adjust role if needed

### Role Best Practices

✅ **DO:**
- Follow principle of least privilege
- Document role purposes
- Review roles quarterly
- Test new roles before deployment
- Keep roles simple and clear
- Use descriptive role names

❌ **DON'T:**
- Give everyone administrator access
- Create too many similar roles
- Modify system roles unnecessarily
- Delete roles without checking users
- Grant permissions "just in case"
- Ignore approval limits

### Compliance and Auditing

**Role Changes Logged:**
- All role modifications logged in audit log
- Who made changes
- What changed
- When changed
- Why changed (if reason provided)

**Compliance Reports:**
- User access report
- Role assignment report
- Permission changes report
- Segregation of duties report

---

## Administration Module Summary

### Key Takeaways

✅ **User Management**
- Create and manage user accounts
- Assign roles and permissions
- Reset passwords and unlock accounts
- Monitor user activity

✅ **Branch Management**
- Configure business locations
- Set operating hours and contacts
- Manage branch-specific settings
- Track branch performance

✅ **Audit Log**
- Complete activity tracking
- Security monitoring
- Compliance reporting
- Troubleshooting tool

✅ **System Settings**
- Company-wide configuration
- Security policies
- Email and notifications
- Backup and recovery

✅ **Role Access Control**
- Define permissions
- Control access levels
- Set approval limits
- Ensure security

### Common Tasks Quick Reference

| Task | Steps |
|------|-------|
| Create User | Administration → User Management → New User |
| Reset Password | Select user → Reset Password button |
| Add Branch | Administration → Branch Management → New Branch |
| View Audit Log | Administration → Audit Log |
| Change Settings | Administration → System Settings → Select tab |
| Modify Role | Administration → Role Access Control → Edit |

### Support and Help

**Need Help?**
- Press F1 for context-sensitive help
- Check [User Manual Index](USER_MANUAL_00_INDEX.md)
- Contact IT Support: support@ovendelights.co.za
- Phone: 011-XXX-XXXX

---

**Next Module:** [Stockroom Management](USER_MANUAL_03_STOCKROOM.md)

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Next Review:** January 2026
