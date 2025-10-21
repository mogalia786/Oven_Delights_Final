-- SARS Compliance Tables for Tax Submissions
-- Creates tables to support VAT201, EMP201, IRP5 and other SARS requirements

-- VAT Transactions table for VAT201 reporting
CREATE TABLE dbo.VATTransactions (
    VATTransactionID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID INT NOT NULL,
    TransactionDate DATE NOT NULL,
    VATType VARCHAR(20) NOT NULL, -- 'Output', 'Input', 'Exempt', 'BadDebtRecovered', 'Adjustment'
    VATRate DECIMAL(5,2) NOT NULL DEFAULT 15.00, -- Current SA VAT rate is 15%
    TaxableAmount DECIMAL(18,2) NOT NULL,
    VATAmount DECIMAL(18,2) NOT NULL,
    SupplierID INT NULL,
    CustomerID INT NULL,
    InvoiceNumber VARCHAR(50) NULL,
    Description NVARCHAR(255) NULL,
    BranchID INT NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedBy INT NULL,
    UpdatedAt DATETIME2 NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_VATTransactions_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_VATTransactions_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_VATTransactions_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_VATTransactions_VATType CHECK (VATType IN ('Output', 'Input', 'Exempt', 'BadDebtRecovered', 'Adjustment')),
    CONSTRAINT CK_VATTransactions_VATRate CHECK (VATRate >= 0 AND VATRate <= 100)
);

-- VAT Returns tracking table
CREATE TABLE dbo.VATReturns (
    VATReturnID INT IDENTITY(1,1) PRIMARY KEY,
    PeriodStart DATE NOT NULL,
    PeriodEnd DATE NOT NULL,
    DueDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Submitted', 'Accepted', 'Rejected'
    StandardRatedSupplies DECIMAL(18,2) NOT NULL DEFAULT 0,
    OutputVATStandard DECIMAL(18,2) NOT NULL DEFAULT 0,
    ZeroRatedSupplies DECIMAL(18,2) NOT NULL DEFAULT 0,
    ExemptSupplies DECIMAL(18,2) NOT NULL DEFAULT 0,
    InputVAT DECIMAL(18,2) NOT NULL DEFAULT 0,
    BadDebtsRecovered DECIMAL(18,2) NOT NULL DEFAULT 0,
    Adjustments DECIMAL(18,2) NOT NULL DEFAULT 0,
    NetVATPayable DECIMAL(18,2) NOT NULL DEFAULT 0,
    SubmissionDate DATETIME2 NULL,
    SARSReference VARCHAR(50) NULL,
    ExportedFilePath NVARCHAR(500) NULL,
    BranchID INT NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedBy INT NULL,
    UpdatedAt DATETIME2 NULL,
    
    CONSTRAINT FK_VATReturns_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_VATReturns_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_VATReturns_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_VATReturns_Status CHECK (Status IN ('Pending', 'Submitted', 'Accepted', 'Rejected')),
    CONSTRAINT CK_VATReturns_Period CHECK (PeriodEnd > PeriodStart)
);

-- Employee master table for payroll
CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNumber VARCHAR(20) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    IDNumber VARCHAR(13) NOT NULL UNIQUE,
    TaxNumber VARCHAR(20) NULL,
    PassportNumber VARCHAR(20) NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL, -- 'M', 'F'
    MaritalStatus VARCHAR(20) NOT NULL, -- 'Single', 'Married', 'Divorced', 'Widowed'
    
    -- Contact details
    Email VARCHAR(100) NULL,
    PhoneNumber VARCHAR(20) NULL,
    Address NVARCHAR(255) NULL,
    City NVARCHAR(50) NULL,
    PostalCode VARCHAR(10) NULL,
    
    -- Employment details
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    Department NVARCHAR(50) NULL,
    BasicSalary DECIMAL(18,2) NOT NULL,
    
    -- Tax details
    TaxDirective VARCHAR(50) NULL,
    MedicalAidNumber VARCHAR(50) NULL,
    MedicalAidDependents INT NOT NULL DEFAULT 0,
    PensionFundNumber VARCHAR(50) NULL,
    
    BranchID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedBy INT NULL,
    UpdatedAt DATETIME2 NULL,
    
    CONSTRAINT FK_Employees_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_Employees_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Employees_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_Employees_Gender CHECK (Gender IN ('M', 'F')),
    CONSTRAINT CK_Employees_MaritalStatus CHECK (MaritalStatus IN ('Single', 'Married', 'Divorced', 'Widowed'))
);

-- Payroll transactions for EMP201 and IRP5 reporting
CREATE TABLE dbo.PayrollTransactions (
    PayrollTransactionID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PayPeriodStart DATE NOT NULL,
    PayPeriodEnd DATE NOT NULL,
    PayDate DATE NOT NULL,
    
    -- Income components
    GrossSalary DECIMAL(18,2) NOT NULL DEFAULT 0,
    Overtime DECIMAL(18,2) NOT NULL DEFAULT 0,
    Allowances DECIMAL(18,2) NOT NULL DEFAULT 0, -- Travel, housing, etc.
    Benefits DECIMAL(18,2) NOT NULL DEFAULT 0, -- Taxable benefits
    Commission DECIMAL(18,2) NOT NULL DEFAULT 0,
    Bonus DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Deductions
    Deductions DECIMAL(18,2) NOT NULL DEFAULT 0, -- General deductions
    PensionContributions DECIMAL(18,2) NOT NULL DEFAULT 0,
    MedicalAidContributions DECIMAL(18,2) NOT NULL DEFAULT 0,
    UIFEmployee DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Tax calculations
    TaxableIncome DECIMAL(18,2) NOT NULL DEFAULT 0,
    PAYEDeducted DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Employer contributions
    UIFEmployer DECIMAL(18,2) NOT NULL DEFAULT 0,
    SDL DECIMAL(18,2) NOT NULL DEFAULT 0, -- Skills Development Levy
    ETI DECIMAL(18,2) NOT NULL DEFAULT 0, -- Employment Tax Incentive
    
    -- Net pay
    NetPay DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    PayrollBatchID INT NULL,
    BranchID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedBy INT NULL,
    UpdatedAt DATETIME2 NULL,
    
    CONSTRAINT FK_PayrollTransactions_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID),
    CONSTRAINT FK_PayrollTransactions_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_PayrollTransactions_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_PayrollTransactions_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_PayrollTransactions_Period CHECK (PayPeriodEnd > PayPeriodStart)
);

-- EMP201 Returns tracking
CREATE TABLE dbo.EMP201Returns (
    EMP201ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    PeriodStart DATE NOT NULL,
    PeriodEnd DATE NOT NULL,
    DueDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    TotalPAYE DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalUIF DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalSDL DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalETI DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalLiability DECIMAL(18,2) NOT NULL DEFAULT 0,
    EmployeeCount INT NOT NULL DEFAULT 0,
    SubmissionDate DATETIME2 NULL,
    SARSReference VARCHAR(50) NULL,
    ExportedFilePath NVARCHAR(500) NULL,
    BranchID INT NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedBy INT NULL,
    UpdatedAt DATETIME2 NULL,
    
    CONSTRAINT FK_EMP201Returns_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_EMP201Returns_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_EMP201Returns_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_EMP201Returns_Status CHECK (Status IN ('Pending', 'Submitted', 'Accepted', 'Rejected'))
);

-- IRP5 Certificates tracking
CREATE TABLE dbo.IRP5Certificates (
    IRP5CertificateID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    TaxYear INT NOT NULL,
    CertificateNumber VARCHAR(20) NOT NULL,
    GrossIncome DECIMAL(18,2) NOT NULL DEFAULT 0,
    Allowances DECIMAL(18,2) NOT NULL DEFAULT 0,
    TaxableBenefits DECIMAL(18,2) NOT NULL DEFAULT 0,
    Deductions DECIMAL(18,2) NOT NULL DEFAULT 0,
    TaxableIncome DECIMAL(18,2) NOT NULL DEFAULT 0,
    PAYEDeducted DECIMAL(18,2) NOT NULL DEFAULT 0,
    UIFContributions DECIMAL(18,2) NOT NULL DEFAULT 0,
    PensionContributions DECIMAL(18,2) NOT NULL DEFAULT 0,
    MedicalAidContributions DECIMAL(18,2) NOT NULL DEFAULT 0,
    EmploymentStartDate DATE NULL,
    EmploymentEndDate DATE NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Draft',
    IssuedDate DATE NULL,
    ExportedFilePath NVARCHAR(500) NULL,
    BranchID INT NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedBy INT NULL,
    UpdatedAt DATETIME2 NULL,
    
    CONSTRAINT FK_IRP5Certificates_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID),
    CONSTRAINT FK_IRP5Certificates_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_IRP5Certificates_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_IRP5Certificates_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_IRP5Certificates_Status CHECK (Status IN ('Draft', 'Issued', 'Submitted')),
    CONSTRAINT UK_IRP5Certificates_Employee_Year UNIQUE (EmployeeID, TaxYear)
);

-- SARS submission log for audit trail
CREATE TABLE dbo.SARSSubmissionLog (
    SubmissionLogID INT IDENTITY(1,1) PRIMARY KEY,
    SubmissionType VARCHAR(20) NOT NULL, -- 'VAT201', 'EMP201', 'IRP5', 'EMP501'
    ReferenceID INT NOT NULL, -- ID of the related return/certificate
    SubmissionDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Status VARCHAR(20) NOT NULL, -- 'Pending', 'Submitted', 'Accepted', 'Rejected', 'Error'
    SARSReference VARCHAR(50) NULL,
    ResponseMessage NVARCHAR(1000) NULL,
    FilePath NVARCHAR(500) NULL,
    BranchID INT NOT NULL,
    SubmittedBy INT NOT NULL,
    
    CONSTRAINT FK_SARSSubmissionLog_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_SARSSubmissionLog_SubmittedBy FOREIGN KEY (SubmittedBy) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_SARSSubmissionLog_Type CHECK (SubmissionType IN ('VAT201', 'EMP201', 'IRP5', 'EMP501')),
    CONSTRAINT CK_SARSSubmissionLog_Status CHECK (Status IN ('Pending', 'Submitted', 'Accepted', 'Rejected', 'Error'))
);

-- Create indexes for performance
CREATE INDEX IX_VATTransactions_Date ON dbo.VATTransactions(TransactionDate);
CREATE INDEX IX_VATTransactions_Type ON dbo.VATTransactions(VATType);
CREATE INDEX IX_VATTransactions_Branch ON dbo.VATTransactions(BranchID);

CREATE INDEX IX_PayrollTransactions_Employee ON dbo.PayrollTransactions(EmployeeID);
CREATE INDEX IX_PayrollTransactions_Period ON dbo.PayrollTransactions(PayPeriodStart, PayPeriodEnd);
CREATE INDEX IX_PayrollTransactions_Branch ON dbo.PayrollTransactions(BranchID);

CREATE INDEX IX_Employees_Number ON dbo.Employees(EmployeeNumber);
CREATE INDEX IX_Employees_IDNumber ON dbo.Employees(IDNumber);
CREATE INDEX IX_Employees_Branch ON dbo.Employees(BranchID);

CREATE INDEX IX_VATReturns_Period ON dbo.VATReturns(PeriodStart, PeriodEnd);
CREATE INDEX IX_VATReturns_Status ON dbo.VATReturns(Status);
CREATE INDEX IX_VATReturns_DueDate ON dbo.VATReturns(DueDate);

CREATE INDEX IX_EMP201Returns_Period ON dbo.EMP201Returns(PeriodStart, PeriodEnd);
CREATE INDEX IX_EMP201Returns_Status ON dbo.EMP201Returns(Status);
CREATE INDEX IX_EMP201Returns_DueDate ON dbo.EMP201Returns(DueDate);

CREATE INDEX IX_IRP5Certificates_TaxYear ON dbo.IRP5Certificates(TaxYear);
CREATE INDEX IX_IRP5Certificates_Employee ON dbo.IRP5Certificates(EmployeeID);
CREATE INDEX IX_IRP5Certificates_Status ON dbo.IRP5Certificates(Status);

CREATE INDEX IX_SARSSubmissionLog_Type ON dbo.SARSSubmissionLog(SubmissionType);
CREATE INDEX IX_SARSSubmissionLog_Date ON dbo.SARSSubmissionLog(SubmissionDate);
CREATE INDEX IX_SARSSubmissionLog_Status ON dbo.SARSSubmissionLog(Status);

PRINT 'SARS compliance tables created successfully';
