-- =============================================
-- Oven Delights ERP - Complete Database Schema
-- Generated on: 2025-08-07
-- =============================================

-- =============================================
-- Table: Users
-- =============================================
CREATE TABLE [dbo].[Users](
    [UserID] [int] IDENTITY(1,1) NOT NULL,
    [Username] [nvarchar](50) NOT NULL,
    [Password] [nvarchar](255) NULL,
    [Email] [nvarchar](128) NULL,
    [FirstName] [nvarchar](50) NULL,
    [LastName] [nvarchar](50) NULL,
    [RoleID] [int] NOT NULL,
    [BranchID] [int] NULL,
    [CreatedDate] [datetime] NULL,
    [LastLogin] [datetime] NULL,
    [IsActive] [bit] NULL,
    [FailedLoginAttempts] [int] NULL,
    [LastFailedLogin] [datetime] NULL,
    [PasswordLastChanged] [datetime] NULL,
    [TwoFactorEnabled] [bit] NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [UQ_Username] UNIQUE NONCLUSTERED ([Username] ASC),
    CONSTRAINT [UQ_Email] UNIQUE NONCLUSTERED ([Email] ASC)
);

-- =============================================
-- Table: Branches
-- =============================================
CREATE TABLE [dbo].[Branches](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [BranchName] [nvarchar](100) NOT NULL,
    [Prefix] [nvarchar](10) NOT NULL,
    CONSTRAINT [PK_Branches] PRIMARY KEY CLUSTERED ([ID] ASC)
);

-- =============================================
-- Table: Roles
-- =============================================
CREATE TABLE [dbo].[Roles](
    [RoleID] [int] IDENTITY(1,1) NOT NULL,
    [RoleName] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleID] ASC),
    CONSTRAINT [UQ_RoleName] UNIQUE NONCLUSTERED ([RoleName] ASC)
);

-- =============================================
-- Foreign Key Constraints
-- =============================================
ALTER TABLE [dbo].[Users] WITH CHECK 
    ADD CONSTRAINT [FK_Users_Roles] FOREIGN KEY([RoleID])
    REFERENCES [dbo].[Roles] ([RoleID]);

ALTER TABLE [dbo].[Users] WITH CHECK 
    ADD CONSTRAINT [FK_Users_Branches] FOREIGN KEY([BranchID])
    REFERENCES [dbo].[Branches] ([ID]);

-- =============================================
-- Indexes
-- =============================================
CREATE NONCLUSTERED INDEX [IX_Users_RoleID] ON [dbo].[Users] ([RoleID] ASC);
CREATE NONCLUSTERED INDEX [IX_Users_BranchID] ON [dbo].[Users] ([BranchID] ASC);
CREATE NONCLUSTERED INDEX [IX_Users_LastLogin] ON [dbo].[Users] ([LastLogin] ASC);

-- =============================================
-- Default Constraints
-- =============================================
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedDate];
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive];
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [FailedLoginAttempts];
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [TwoFactorEnabled];

-- =============================================
-- Stored Procedures
-- =============================================

-- sp_CreateJournalEntry
-- Creates a new journal entry and returns JournalID.
CREATE PROCEDURE [dbo].[sp_CreateJournalEntry]
    @JournalDate DATE,
    @Reference NVARCHAR(50),
    @Description NVARCHAR(255),
    @FiscalPeriodID INT,
    @CreatedBy INT,
    @BranchID INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[JournalHeaders]
    (
        [JournalNumber],
        [JournalDate],
        [Reference],
        [Description],
        [FiscalPeriodID],
        [CreatedBy],
        [BranchID],
        [IsPosted],
        [PostedDate],
        [PostedBy]
    )
    VALUES
    (
        dbo.fn_GetNextDocumentNumber('JOURNAL', @BranchID, @CreatedBy),
        @JournalDate,
        @Reference,
        @Description,
        @FiscalPeriodID,
        @CreatedBy,
        @BranchID,
        0,  -- IsPosted
        NULL, -- PostedDate
        NULL  -- PostedBy
    )
    
    SET @JournalID = SCOPE_IDENTITY();
    
    RETURN @JournalID;
END;

-- sp_AddJournalDetail
-- Adds a journal detail line to a journal.
CREATE PROCEDURE [dbo].[sp_AddJournalDetail]
    @JournalID INT,
    @AccountID INT,
    @Debit DECIMAL(18, 2) = 0,
    @Credit DECIMAL(18, 2) = 0,
    @Description NVARCHAR(255) = NULL,
    @Reference1 NVARCHAR(50) = NULL,
    @Reference2 NVARCHAR(50) = NULL,
    @CostCenterID INT = NULL,
    @ProjectID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LineNumber INT;
    
    -- Get the next line number for this journal
    SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1 
    FROM [dbo].[JournalDetails] 
    WHERE JournalID = @JournalID;
    
    INSERT INTO [dbo].[JournalDetails]
    (
        [JournalID],
        [LineNumber],
        [AccountID],
        [Debit],
        [Credit],
        [Description],
        [Reference1],
        [Reference2],
        [CostCenterID],
        [ProjectID]
    )
    VALUES
    (
        @JournalID,
        @LineNumber,
        @AccountID,
        @Debit,
        @Credit,
        @Description,
        @Reference1,
        @Reference2,
        @CostCenterID,
        @ProjectID
    );
    
    RETURN @LineNumber;
END;

-- sp_PostJournal
-- Posts a journal and updates account balances.
CREATE PROCEDURE [dbo].[sp_PostJournal]
    @JournalID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update journal header
        UPDATE [dbo].[JournalHeaders]
        SET 
            [IsPosted] = 1,
            [PostedDate] = GETDATE(),
            [PostedBy] = @PostedBy
        WHERE [JournalID] = @JournalID;
        
        -- Update account balances (simplified example)
        -- Note: In a real implementation, you would need to handle various account types
        -- and maintain separate period balances
        UPDATE a
        SET a.Balance = a.Balance + d.Debit - d.Credit
        FROM [dbo].[GLAccounts] a
        INNER JOIN [dbo].[JournalDetails] d ON a.AccountID = d.AccountID
        WHERE d.JournalID = @JournalID;
        
        COMMIT TRANSACTION;
        RETURN 0; -- Success
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Log the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN -1; -- Error
    END CATCH;
END;

-- =============================================
-- Functions
-- =============================================

-- fn_GetNextDocumentNumber
-- Generates the next document number for a given document type
CREATE FUNCTION [dbo].[fn_GetNextDocumentNumber]
(
    @DocumentType VARCHAR(20),
    @BranchID INT,
    @UserID INT
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @NextNumber INT;
    DECLARE @Prefix VARCHAR(10);
    DECLARE @NumberLength INT;
    DECLARE @BranchPrefix VARCHAR(10) = '';
    
    -- Get branch prefix if branch-specific numbering is enabled
    IF EXISTS (SELECT 1 FROM [dbo].[DocumentNumbering] 
               WHERE DocumentType = @DocumentType AND BranchSpecific = 1)
    BEGIN
        SELECT @BranchPrefix = ISNULL(Prefix, '')
        FROM [dbo].[Branches]
        WHERE ID = @BranchID;
    END
    
    -- Get or create document numbering record
    IF NOT EXISTS (SELECT 1 FROM [dbo].[DocumentNumbering] 
                   WHERE DocumentType = @DocumentType)
    BEGIN
        INSERT INTO [dbo].[DocumentNumbering]
        (
            [DocumentType],
            [Prefix],
            [NextNumber],
            [NumberLength],
            [BranchSpecific],
            [LastUsedNumber],
            [LastUsedDate],
            [ModifiedDate],
            [ModifiedBy]
        )
        VALUES
        (
            @DocumentType,
            @BranchPrefix,
            1,          -- Start at 1
            6,          -- Default length of 6
            1,          -- Branch specific by default
            NULL,       -- No last used number yet
            NULL,       -- No last used date yet
            GETDATE(),
            @UserID
        );
    END
    
    -- Get the next number in a thread-safe way
    UPDATE [dbo].[DocumentNumbering] WITH (SERIALIZABLE)
    SET 
        @NextNumber = NextNumber,
        NextNumber = NextNumber + 1,
        LastUsedNumber = @BranchPrefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), 
                          ISNULL(NumberLength, 6)),
        LastUsedDate = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = @UserID
    WHERE DocumentType = @DocumentType;
    
    -- Format the number with leading zeros
    DECLARE @NumberString VARCHAR(10) = RIGHT('000000' + CAST(@NextNumber AS VARCHAR(10)), 
                                           ISNULL((SELECT NumberLength FROM [dbo].[DocumentNumbering] 
                                                  WHERE DocumentType = @DocumentType), 6));
    
    -- Combine prefix and number
    RETURN @BranchPrefix + @NumberString;
END;

-- =============================================
-- Initial Data
-- =============================================

-- Insert default roles if they don't exist
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Super-Administrator')
    INSERT INTO [dbo].[Roles] ([RoleName]) VALUES ('Super-Administrator');
    
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Stockroom_Manager')
    INSERT INTO [dbo].[Roles] ([RoleName]) VALUES ('Stockroom_Manager');
    
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Manufacturing_Manager')
    INSERT INTO [dbo].[Roles] ([RoleName]) VALUES ('Manufacturing_Manager');
    
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Admin')
    INSERT INTO [dbo].[Roles] ([RoleName]) VALUES ('Admin');
    
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Retail-Manager')
    INSERT INTO [dbo].[Roles] ([RoleName]) VALUES ('Retail-Manager');

-- Insert default branch if none exists
IF NOT EXISTS (SELECT 1 FROM [dbo].[Branches])
    INSERT INTO [dbo].[Branches] ([BranchName], [Prefix]) 
    VALUES ('Head Office', 'HO');

-- =============================================
-- End of Schema Script
-- =============================================
