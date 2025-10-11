# 🍞 Oven Delights ERP - User Management System

## 📋 Overview

The **Oven Delights ERP User Management System** is a comprehensive, secure, and modern enterprise resource planning solution designed specifically for the Administrator Module. This system provides advanced user authentication, role-based access control, real-time monitoring, and comprehensive audit logging.

## ✨ Key Features

### 🔐 **Advanced Security**
- **BCrypt Password Hashing** - Industry-standard password encryption
- **JWT Token Authentication** - Secure session management
- **Two-Factor Authentication** - Enhanced security layer
- **IP Whitelisting** - Network-level access control
- **Failed Login Protection** - Automatic account lockout
- **Password Policy Enforcement** - Configurable complexity requirements
- **Session Timeout Management** - Automatic security logout

### 👥 **User Management**
- **Multi-Role Support** - SuperAdmin, BranchAdmin, Manager, Employee
- **Branch-Based Access Control** - Multi-location support
- **User Profile Management** - Complete user information
- **Password Reset Functionality** - Secure password recovery
- **Account Activation/Deactivation** - User lifecycle management
- **Bulk User Operations** - Efficient user management

### 📊 **Graphical Dashboard**
- **Real-Time Charts** - Live data visualization with Chart.js
- **User Activity Monitoring** - Active/Inactive user tracking
- **Login Frequency Analysis** - Daily/Weekly/Monthly statistics
- **Branch Distribution** - Multi-location overview
- **Role-Based Access Matrix** - Permission visualization
- **Security Alerts Timeline** - Real-time security monitoring
- **User Registration Trends** - Growth analytics

### 🔍 **Audit & Compliance**
- **Comprehensive Audit Logging** - Every action tracked
- **Security Event Monitoring** - Real-time threat detection
- **Data Change Tracking** - Before/After value logging
- **User Activity Reports** - Detailed usage analytics
- **Export Capabilities** - CSV/Excel report generation
- **Retention Management** - Configurable log retention

### 🌐 **Real-Time Features**
- **SignalR Integration** - Live dashboard updates
- **Instant Notifications** - Real-time security alerts
- **Concurrent User Monitoring** - Active session tracking
- **Live Status Updates** - Real-time user status changes

## 🏗️ **Architecture**

### **Database Schema**
- **Users Table** - Complete user information with security fields
- **Branches Table** - Multi-branch hierarchy support
- **UserSessions Table** - Session management and tracking
- **AuditLog Table** - Comprehensive audit trail
- **UserPermissions Table** - Granular permission control
- **SystemSettings Table** - Configuration management

### **Application Layers**
- **Presentation Layer** - Modern WinForms UI with Chart.js integration
- **Business Logic Layer** - Authentication, authorization, and business rules
- **Data Access Layer** - SQL Server database operations
- **Security Layer** - Encryption, hashing, and token management
- **Audit Layer** - Comprehensive logging and monitoring

## 🚀 **Getting Started**

### **Prerequisites**
- Visual Studio 2019 or later
- .NET Framework 4.8
- SQL Server 2016 or later (or Azure SQL Database)
- Internet connection for Chart.js and real-time features

### **Installation Steps**

1. **Clone the Repository**
   ```bash
   git clone https://github.com/ovendelights/erp-system.git
   cd OvenDelightsERP
   ```

2. **Restore NuGet Packages**
   ```bash
   nuget restore
   ```

3. **Configure Database Connection**
   - Update `App.config` with your SQL Server connection string
   - Run the database creation script: `Database/CreateTables.sql`

4. **Build and Run**
   ```bash
   msbuild OvenDelightsERP.sln
   ```

5. **Initial Login**
   - Username: `R@j3np1ll@y`
   - Password: `12345678` (change immediately after first login)

## 🔧 **Configuration**

### **App.config Settings**

```xml
<!-- Security Settings -->
<add key="PasswordMinLength" value="8" />
<add key="SessionTimeoutMinutes" value="30" />
<add key="MaxFailedLoginAttempts" value="5" />

<!-- JWT Settings -->
<add key="JWTSecret" value="your-secret-key" />
<add key="JWTExpiryHours" value="8" />

<!-- Database Connection -->
<connectionStrings>
  <add name="OvenDelightsERP" 
       connectionString="your-connection-string" />
</connectionStrings>
```

### **System Settings (Database)**
All runtime settings are stored in the `SystemSettings` table and can be modified through the System Settings form.

## 📊 **Dashboard Features**

### **Real-Time Charts**
1. **User Activity Pie Chart** - Active/Inactive/Locked users
2. **Login Frequency Bar Chart** - Daily/Weekly/Monthly statistics
3. **Branch Distribution Donut Chart** - Multi-location overview
4. **Role Access Matrix** - Permission level visualization
5. **Registration Trends Line Chart** - User growth over time
6. **Security Alerts Timeline** - Real-time threat monitoring

### **Key Performance Indicators**
- Total Users
- Active Users
- Total Branches
- Active Sessions
- Security Alerts
- System Health Score

## 🔐 **Security Features**

### **Authentication**
- BCrypt password hashing with salt
- JWT token-based session management
- Two-factor authentication support
- IP address validation
- Device fingerprinting

### **Authorization**
- Role-based access control (RBAC)
- Granular permission system
- Branch-level data isolation
- Module-specific permissions
- Action-level security

### **Audit & Monitoring**
- Complete audit trail
- Real-time security alerts
- Failed login attempt tracking
- Data change monitoring
- Session activity logging

## 📈 **Reporting**

### **Built-in Reports**
- User Activity Report
- Login/Logout Logs
- Security Incident Report
- Branch Performance Metrics
- Role Distribution Analysis
- System Health Report

### **Export Options**
- PDF Reports (Crystal Reports)
- Excel Spreadsheets
- CSV Data Files
- Email Delivery
- Scheduled Reports

## 🔄 **Real-Time Features**

### **SignalR Integration**
- Live dashboard updates
- Instant security notifications
- Real-time user status changes
- Concurrent session monitoring
- System health alerts

### **Notification System**
- Security breach alerts
- Failed login notifications
- System maintenance notices
- User activity updates
- Performance warnings

## 🛠️ **Development**

### **Project Structure**
```
OvenDelightsERP/
├── Forms/                 # UI Forms
│   ├── LoginForm.vb
│   ├── MainDashboard.vb
│   └── UserManagementForm.vb
├── Classes/               # Business Logic
│   ├── AuthenticationManager.vb
│   ├── AuditLogger.vb
│   └── DashboardDataManager.vb
├── Models/                # Data Models
│   └── User.vb
├── Database/              # SQL Scripts
│   └── CreateTables.sql
└── Reports/               # Crystal Reports
```

### **Key Classes**
- **AuthenticationManager** - User authentication and session management
- **AuditLogger** - Comprehensive audit logging
- **DashboardDataManager** - Dashboard data and statistics
- **User** - User model with role-based permissions

## 🔧 **Maintenance**

### **Database Maintenance**
- Regular audit log purging (configurable retention)
- Index optimization for performance
- Backup and recovery procedures
- Performance monitoring

### **Security Maintenance**
- Regular password policy updates
- Security patch management
- Audit log review
- Access permission audits

## 📞 **Support**

### **Technical Support**
- Email: support@ovendelights.co.za
- Phone: +27 11 123 4567
- Documentation: [Internal Wiki]
- Issue Tracking: [Internal System]

### **System Requirements**
- **OS**: Windows 10/11, Windows Server 2016+
- **Framework**: .NET Framework 4.8
- **Database**: SQL Server 2016+ or Azure SQL
- **Memory**: 4GB RAM minimum, 8GB recommended
- **Storage**: 500MB application, 10GB+ database

## 📄 **License**

This software is proprietary to Oven Delights and is protected by copyright law. Unauthorized reproduction or distribution is prohibited.

## 🔄 **Version History**

### **Version 1.0.0** (Current)
- Initial release
- Complete user management system
- Advanced security features
- Real-time dashboard
- Comprehensive audit logging
- Multi-branch support

---

## 🎯 **Next Steps**

This User Management System is the foundation for the complete Oven Delights ERP. The next modules to be implemented are:

1. **Stockroom Management** - Inventory tracking and control
2. **Manufacturing & Production** - Production planning and monitoring
3. **Retail & Point of Sale** - Sales and customer management
4. **Accounting & Financial Management** - Complete financial system
5. **E-commerce Platform** - Online sales integration
6. **Reporting Module** - Advanced analytics and reporting
7. **Branding Module** - Marketing and brand management

Each module will integrate seamlessly with this User Management System, providing a unified and comprehensive ERP solution.

---

**🍞 Oven Delights ERP - Baking Success Through Technology**
