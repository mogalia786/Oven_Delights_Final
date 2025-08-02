# Oven Delights ERP System

## Overview
A comprehensive Enterprise Resource Planning (ERP) system built with VB.NET WinForms, designed with Pastel accounting compatibility and full Azure SQL database integration.

## Project Status

### ✅ COMPLETED MODULES

#### 1. Administrator Module (95% Complete)
**Features Implemented:**
- ✅ User Management System with CRUD operations
- ✅ Role-based access control with permissions
- ✅ Branch management and hierarchy
- ✅ Advanced security features (BCrypt, JWT, 2FA support)
- ✅ Comprehensive audit logging
- ✅ System settings and configuration
- ✅ Real-time notifications (SignalR)
- ✅ Dashboard with Chart.js integration
- ✅ Crystal Reports integration
- ✅ Session management with timeout

**Database Tables:**
- Users, Roles, Branches, UserSessions, AuditLog
- UserPermissions, UserPreferences, PasswordHistory
- Notifications, UserNotifications, SystemSettings

**Forms Completed:**
- LoginForm, MainDashboard, UserManagementForm
- UserAddEditForm, UserProfileForm, PasswordChangeForm
- BranchManagementForm, AuditLogViewer, SystemSettingsForm

#### 2. Stockroom Module (75% Complete)
**Features Implemented:**
- ✅ Supplier management (Creditors)
- ✅ Raw materials inventory tracking
- ✅ Purchase order management
- ✅ Stock level monitoring
- ✅ Database integration with minimal schema
- ✅ StockroomManagementForm with 4 functional tabs
- ✅ StockTransferForm and StockAdjustmentForm

**Database Tables:**
- Suppliers, RawMaterials, PurchaseOrders
- JournalEntries, JournalEntryLines (for accounting integration)

**Forms Completed:**
- StockroomManagementForm (with tabs: Raw Materials, Suppliers, Purchase Orders, Low Stock)
- StockTransferForm, StockAdjustmentForm

### 🚧 PENDING MODULES

#### 3. Manufacturing Module (15% Complete)
**Planned Features:**
- Production planning and scheduling
- Bill of Materials (BOM) management
- Work order tracking
- Quality control processes
- Equipment maintenance scheduling

#### 4. Retail & POS Module (8% Complete)
**Planned Features:**
- Point of Sale system
- Customer management
- Sales transactions
- Inventory integration
- Receipt printing

#### 5. Accounting Module (5% Complete)
**Planned Features:**
- General Ledger integration
- Accounts Payable/Receivable
- Financial reporting
- Trial Balance, Balance Sheet, Income Statement
- Multi-currency support

#### 6. E-commerce Module (3% Complete)
**Planned Features:**
- Online store integration
- Product catalog management
- Order synchronization
- Customer portal

#### 7. Reporting Module (5% Complete)
**Planned Features:**
- Custom report builder
- Financial reports
- Operational reports
- Business intelligence dashboard

#### 8. Branding Module (2% Complete)
**Planned Features:**
- Brand asset management
- Marketing materials
- Corporate identity management

## Technical Architecture

### Database
- **Platform:** Azure SQL Database
- **Server:** mogalia.database.windows.net
- **Database:** OvenDelightsERP
- **Connection:** Integrated via Microsoft.Data.SqlClient

### Framework
- **Platform:** .NET Framework 4.8
- **UI:** Windows Forms (WinForms)
- **Language:** VB.NET
- **IDE:** Visual Studio

### Key Dependencies
- Microsoft.Data.SqlClient (Database connectivity)
- BCrypt.Net-Next (Password hashing)
- Microsoft.Web.WebView2 (Chart integration)
- System.IdentityModel.Tokens.Jwt (JWT authentication)
- Microsoft.AspNetCore.SignalR.Client (Real-time features)
- EPPlus (Excel export)

## Database Schema
Comprehensive database documentation available in:
`Documentation/DatabaseSchema.md`

## Getting Started

### Prerequisites
- Visual Studio 2019 or later
- .NET Framework 4.8
- Azure SQL Database access

### Login Credentials
- **Username:** R@j3np1ll@y
- **Password:** 12345678

### Build Instructions
1. Clone the repository
2. Open `Oven-Delights-ERP.sln` in Visual Studio
3. Restore NuGet packages
4. Build solution
5. Run application

## Development Notes

### Current Issues
- StockroomService compilation errors due to duplicate functions (being resolved)
- Workflow module display issues (under investigation)
- Database schema documentation needs updates for new tables

### Next Development Priorities
1. **Fix StockroomService compilation errors**
2. **Implement full CRUD operations for Stockroom module**
3. **Begin Manufacturing module development**
4. **Enhance accounting integration**
5. **Implement comprehensive reporting features**

## Workflow Integration
The system includes an AI-powered workflow assistant that guides development through each module's implementation. The workflow system provides:
- Module-specific task guidance
- Comprehensive prompts for Cascade AI integration
- Progress tracking across all 8 modules
- Developer mode with password protection (od1)

## Contributing
This is an internal ERP development project. All development should follow the established patterns and maintain compatibility with the existing database schema.

## License
Internal use only - Oven Delights ERP System

---
*Last Updated: 2025-08-02*
*Version: 1.0.0-alpha*
