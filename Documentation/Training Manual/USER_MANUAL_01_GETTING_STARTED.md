# Getting Started with Oven Delights ERP
## User Training Manual - Module 1

---

## Table of Contents
1. [System Overview](#system-overview)
2. [Logging In](#logging-in)
3. [Understanding the Interface](#understanding-the-interface)
4. [Navigation Basics](#navigation-basics)
5. [User Roles](#user-roles)

---

## System Overview

### What is Oven Delights ERP?

Oven Delights ERP is an integrated business management system that connects all aspects of your bakery operations:

- **Retail** - Point of sale and customer management
- **Stockroom** - Procurement and inventory control
- **Manufacturing** - Production planning and execution
- **Accounting** - Financial management and reporting
- **Administration** - System configuration and user management

### Key Benefits

✅ **Real-time Information** - Instant access to stock levels, sales data, and financial information  
✅ **Integrated Processes** - Data flows automatically between modules  
✅ **Multi-Branch Support** - Manage multiple locations from one system  
✅ **Audit Trail** - Complete history of all transactions  
✅ **Role-Based Security** - Users only see what they need

---

## Logging In

### Step 1: Launch the Application

1. Double-click the **Oven Delights ERP** icon on your desktop
2. Or navigate to: `C:\Program Files\Oven Delights ERP\` and run the executable

### Step 2: Enter Credentials

**Login Screen Fields:**
- **Username:** Your assigned username (case-sensitive)
- **Password:** Your secure password (case-sensitive)
- **Branch:** Select your working branch from dropdown

💡 **Tip:** Your username is typically your first initial + surname (e.g., jsmith)

### Step 3: First-Time Login

On first login, you'll be prompted to:
1. Change your password
2. Set security questions
3. Review user agreement
4. Complete profile information

**Password Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one number
- At least one special character
- Cannot reuse last 5 passwords

### Step 4: Successful Login

After successful login, you'll see:
- Your personalized dashboard
- Menu bar with modules you have access to
- Welcome message with your name
- Current branch displayed in status bar

---

## Understanding the Interface

### Main Window Components

```
┌─────────────────────────────────────────────────────────┐
│ Menu Bar: Retail | Stockroom | Manufacturing | Accounting│
├─────────────────────────────────────────────────────────┤
│ Toolbar: [New] [Save] [Print] [Refresh]                │
├─────────────────────────────────────────────────────────┤
│                                                          │
│                    WORKSPACE AREA                        │
│              (Forms and reports open here)               │
│                                                          │
├─────────────────────────────────────────────────────────┤
│ Status Bar: User: jsmith | Branch: Main | Date: 08/10/25│
└─────────────────────────────────────────────────────────┘
```

### Menu Bar

Located at the top, provides access to all system modules:
- Click menu name to expand
- Hover to see submenu items
- Click submenu item to open form

### Toolbar

Quick access buttons for common functions:
- **New** - Create new record
- **Save** - Save current form
- **Print** - Print current document
- **Refresh** - Reload data
- **Help** - Context-sensitive help

### Workspace Area

Main area where forms and reports open:
- Multiple windows can be open simultaneously (MDI interface)
- Each window has its own title bar
- Minimize, maximize, or close individual windows
- Switch between windows using Window menu or taskbar

### Status Bar

Bottom of screen shows:
- Current user logged in
- Active branch
- Current date and time
- System status messages
- Network connection status

---

## Navigation Basics

### Opening Forms

**Method 1: Using Menus**
1. Click main menu (e.g., Retail)
2. Click submenu item (e.g., Point of Sale)
3. Form opens in workspace

**Method 2: Using Toolbar**
1. Click toolbar button
2. Form opens immediately

**Method 3: Using Keyboard Shortcuts**
- Press `Alt` + underlined letter in menu
- Example: `Alt + R` opens Retail menu

### Working with Forms

**Common Form Elements:**
- **Text boxes** - Type information
- **Dropdowns** - Select from list
- **Date pickers** - Select dates
- **Checkboxes** - Yes/No options
- **Buttons** - Perform actions
- **Grids** - View lists of data

**Form Navigation:**
- `Tab` - Move to next field
- `Shift + Tab` - Move to previous field
- `Enter` - Accept and move to next
- `Esc` - Cancel and close form

### Saving Your Work

**Auto-Save:**
- Some forms auto-save as you work
- Look for "Auto-saved" message in status bar

**Manual Save:**
- Click **Save** button
- Or press `Ctrl + S`
- Confirmation message appears

**Before Closing:**
- System prompts if unsaved changes exist
- Choose: Save, Don't Save, or Cancel

### Searching and Filtering

**Search Box:**
1. Type search term
2. Press Enter or click Search
3. Results appear in grid

**Filters:**
1. Click filter icon in column header
2. Select filter criteria
3. Click Apply
4. Grid shows filtered results

**Sorting:**
- Click column header to sort ascending
- Click again to sort descending
- Hold `Shift` and click multiple columns for multi-level sort

### Printing

**Print Current Form:**
1. Click **Print** button
2. Print dialog appears
3. Select printer
4. Set options (copies, pages, etc.)
5. Click **Print**

**Print Preview:**
1. Click **Print Preview**
2. Review document on screen
3. Adjust if needed
4. Click **Print** or **Close**

**Export Options:**
- **PDF** - Save as PDF file
- **Excel** - Export to Excel
- **Word** - Export to Word
- **Email** - Send via email

### Getting Help

**Context-Sensitive Help:**
- Press `F1` on any form
- Help for that specific form appears

**Help Menu:**
- Click **Help** in menu bar
- Select:
  - User Manual
  - Video Tutorials
  - FAQ
  - Contact Support

**Tooltips:**
- Hover mouse over any button or field
- Tooltip appears with description

---

## User Roles

### Understanding Roles

Your role determines which modules and functions you can access:

### 1. Cashier Role

**Access:**
- ✅ Retail → Point of Sale
- ✅ Retail → Customer Management (view only)
- ❌ No access to purchasing
- ❌ No access to financial reports

**Typical Tasks:**
- Process sales
- Handle returns
- Manage cash drawer
- Assist customers

### 2. Stockroom Clerk Role

**Access:**
- ✅ Stockroom → All functions
- ✅ Retail → Inventory (view only)
- ✅ Goods receiving
- ❌ Cannot approve purchase orders over R5,000

**Typical Tasks:**
- Receive goods
- Create purchase requisitions
- Manage stockroom inventory
- Process GRVs

### 3. Production Manager Role

**Access:**
- ✅ Manufacturing → All functions
- ✅ Stockroom → View inventory
- ✅ Issue materials to production
- ❌ Cannot modify recipes without approval

**Typical Tasks:**
- Create production orders
- Issue materials
- Complete builds
- Track production

### 4. Branch Manager Role

**Access:**
- ✅ All Retail functions
- ✅ All Stockroom functions
- ✅ Approve purchases up to R50,000
- ✅ View branch reports
- ❌ Cannot access other branches
- ❌ Cannot modify system settings

**Typical Tasks:**
- Oversee daily operations
- Approve transactions
- Review reports
- Manage staff

### 5. Accountant Role

**Access:**
- ✅ Accounting → All functions
- ✅ All financial reports
- ✅ View all modules (read-only)
- ❌ Cannot process sales
- ❌ Cannot create purchase orders

**Typical Tasks:**
- Process invoices
- Reconcile accounts
- Generate financial reports
- Manage cash books

### 6. System Administrator Role

**Access:**
- ✅ Full system access
- ✅ All modules
- ✅ User management
- ✅ System configuration
- ✅ All branches

**Typical Tasks:**
- Create users
- Set permissions
- Configure system
- Troubleshoot issues
- Generate all reports

### Requesting Additional Access

If you need access to functions not available in your role:

1. Discuss with your manager
2. Manager submits access request to IT
3. IT reviews and approves
4. Your permissions updated
5. You receive notification

⚠️ **Important:** Never share your login credentials with others. Each user must have their own account for audit trail purposes.

---

## Best Practices

### Security

✅ **DO:**
- Log out when leaving your workstation
- Change password regularly
- Report suspicious activity
- Keep password confidential

❌ **DON'T:**
- Share your login credentials
- Write password on paper
- Leave system unattended while logged in
- Use simple/obvious passwords

### Data Entry

✅ **DO:**
- Double-check information before saving
- Use consistent formatting
- Complete all required fields
- Save work frequently

❌ **DON'T:**
- Enter duplicate records
- Use abbreviations inconsistently
- Leave forms open unnecessarily
- Skip required fields

### System Performance

✅ **DO:**
- Close forms when finished
- Log out at end of day
- Report system errors immediately
- Keep workspace organized

❌ **DON'T:**
- Open excessive windows simultaneously
- Run other programs while using ERP
- Ignore error messages
- Force-close the application

---

## Troubleshooting Common Issues

### Cannot Log In

**Problem:** Login fails  
**Solutions:**
1. Verify username and password (check Caps Lock)
2. Ensure correct branch selected
3. Check network connection
4. Contact IT if account locked

### Form Won't Open

**Problem:** Menu item doesn't respond  
**Solutions:**
1. Check if form already open (minimize/maximize)
2. Close other open forms
3. Restart application
4. Contact IT support

### Data Not Saving

**Problem:** Changes not saved  
**Solutions:**
1. Check for error messages
2. Verify required fields completed
3. Check network connection
4. Try saving again
5. Contact IT if persists

### Slow Performance

**Problem:** System running slowly  
**Solutions:**
1. Close unnecessary forms
2. Clear browser cache (if web-based)
3. Restart application
4. Check network speed
5. Report to IT

---

## Support Contacts

**IT Help Desk:**
- Email: support@ovendelights.co.za
- Phone: 011-XXX-XXXX
- Hours: Monday-Friday, 8:00 AM - 5:00 PM

**Emergency After-Hours:**
- Phone: 082-XXX-XXXX (Critical issues only)

**System Administrator:**
- Email: admin@ovendelights.co.za

---

## Next Steps

Now that you understand the basics, proceed to the module-specific manuals:

- **[Retail Module Manual](USER_MANUAL_02_RETAIL.md)** - If you work in retail/sales
- **[Stockroom Module Manual](USER_MANUAL_03_STOCKROOM.md)** - If you work in procurement
- **[Manufacturing Module Manual](USER_MANUAL_04_MANUFACTURING.md)** - If you work in production
- **[Accounting Module Manual](USER_MANUAL_05_ACCOUNTING.md)** - If you work in finance

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Next Review:** January 2026
