-- =============================================
-- Oven Delights ERP - Complete Database Recreate
-- Drops and recreates all database objects with correct schema
-- =============================================

-- Set NOCOUNT to prevent extra result sets
SET NOCOUNT ON;
GO

-- Use master to drop and recreate the database
USE [master];
GO

-- Drop the database if it exists
IF DB_ID('Oven_Delights_Main') IS NOT NULL
BEGIN
    -- Set database to single user mode to drop connections
    ALTER DATABASE [Oven_Delights_Main] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Oven_Delights_Main];
    PRINT 'Dropped existing Oven_Delights_Main database';
END
GO

-- Create the database with recommended settings
CREATE DATABASE [Oven_Delights_Main]
CONTAINMENT = NONE
ON PRIMARY 
( 
    NAME = N'Oven_Delights_Main', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Oven_Delights_Main.mdf',
    SIZE = 8192KB,
    FILEGROWTH = 65536KB 
)
LOG ON 
( 
    NAME = N'Oven_Delights_Main_log',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Oven_Delights_Main_log.ldf',
    SIZE = 8192KB,
    FILEGROWTH = 65536KB 
);
GO

-- Set recommended database options
ALTER DATABASE [Oven_Delights_Main] SET COMPATIBILITY_LEVEL = 150;
ALTER DATABASE [Oven_Delights_Main] SET ANSI_NULL_DEFAULT OFF;
ALTER DATABASE [Oven_Delights_Main] SET ANSI_NULLS OFF;
ALTER DATABASE [Oven_Delights_Main] SET ANSI_PADDING OFF;
ALTER DATABASE [Oven_Delights_Main] SET ANSI_WARNINGS OFF;
ALTER DATABASE [Oven_Delights_Main] SET ARITHABORT OFF;
ALTER DATABASE [Oven_Delights_Main] SET AUTO_CLOSE OFF;
ALTER DATABASE [Oven_Delights_Main] SET AUTO_SHRINK OFF;
ALTER DATABASE [Oven_Delights_Main] SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE [Oven_Delights_Main] SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE [Oven_Delights_Main] SET CURSOR_DEFAULT GLOBAL;
ALTER DATABASE [Oven_Delights_Main] SET CONCAT_NULL_YIELDS_NULL OFF;
ALTER DATABASE [Oven_Delights_Main] SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE [Oven_Delights_Main] SET QUOTED_IDENTIFIER OFF;
ALTER DATABASE [Oven_Delights_Main] SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE [Oven_Delights_Main] SET DISABLE_BROKER;
ALTER DATABASE [Oven_Delights_Main] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
ALTER DATABASE [Oven_Delights_Main] SET DATE_CORRELATION_OPTIMIZATION OFF;
ALTER DATABASE [Oven_Delights_Main] SET TRUSTWORTHY OFF;
ALTER DATABASE [Oven_Delights_Main] SET ALLOW_SNAPSHOT_ISOLATION ON;
ALTER DATABASE [Oven_Delights_Main] SET PARAMETERIZATION SIMPLE;
ALTER DATABASE [Oven_Delights_Main] SET READ_COMMITTED_SNAPSHOT ON;
ALTER DATABASE [Oven_Delights_Main] SET HONOR_BROKER_PRIORITY OFF;
ALTER DATABASE [Oven_Delights_Main] SET RECOVERY SIMPLE;
ALTER DATABASE [Oven_Delights_Main] SET MULTI_USER;
ALTER DATABASE [Oven_Delights_Main] SET PAGE_VERIFY CHECKSUM;
ALTER DATABASE [Oven_Delights_Main] SET TARGET_RECOVERY_TIME = 60 SECONDS;
ALTER DATABASE [Oven_Delights_Main] SET DELAYED_DURABILITY = DISABLED;
ALTER DATABASE [Oven_Delights_Main] SET ACCELERATED_DATABASE_RECOVERY = OFF;
GO

-- Switch to the new database
USE [Oven_Delights_Main];
GO

-- Create schemas if they don't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
    EXEC('CREATE SCHEMA [dbo]');
GO

-- Enable CLR if not already enabled
IF NOT EXISTS (SELECT 1 FROM sys.configurations WHERE name = 'clr enabled' AND value_in_use = 1)
BEGIN
    EXEC sp_configure 'show advanced options', 1;
    RECONFIGURE;
    EXEC sp_configure 'clr enabled', 1;
    RECONFIGURE;
    PRINT 'CLR enabled successfully';
END
ELSE
    PRINT 'CLR is already enabled';
GO

-- Create message type for service broker (if needed)
IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name = '//OvenDelights/MessageType')
    CREATE MESSAGE TYPE [//OvenDelights/MessageType] VALIDATION = WELL_FORMED_XML;
GO

-- Create contract for service broker (if needed)
IF NOT EXISTS (SELECT * FROM sys.service_contracts WHERE name = '//OvenDelights/Contract')
    CREATE CONTRACT [//OvenDelights/Contract] ([//OvenDelights/MessageType] SENT BY INITIATOR);
GO

-- Create queue for service broker (if needed)
IF NOT EXISTS (SELECT * FROM sys.service_queues WHERE name = 'OvenDelightsQueue')
    CREATE QUEUE [dbo].[OvenDelightsQueue] WITH STATUS = ON, RETENTION = OFF;
GO

-- Create service for service broker (if needed)
IF NOT EXISTS (SELECT * FROM sys.services WHERE name = '//OvenDelights/Service')
    CREATE SERVICE [//OvenDelights/Service] ON QUEUE [dbo].[OvenDelightsQueue] ([//OvenDelights/Contract]);
GO

-- Create error log table for error handling
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLog' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[ErrorLog]
    (
        [ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
        [ErrorTime] [datetime] NOT NULL DEFAULT (getdate()),
        [UserName] [sysname] NOT NULL,
        [ErrorNumber] [int] NOT NULL,
        [ErrorSeverity] [int] NULL,
        [ErrorState] [int] NULL,
        [ErrorProcedure] [nvarchar](128) NULL,
        [ErrorLine] [int] NULL,
        [ErrorMessage] [nvarchar](4000) NOT NULL,
        [ErrorDetails] [nvarchar](max) NULL,
        CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([ErrorLogID] ASC)
    );
    
    PRINT 'Created ErrorLog table';
END
GO

-- Create stored procedure for error logging
IF OBJECT_ID('dbo.uspLogError', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[uspLogError];
GO

CREATE PROCEDURE [dbo].[uspLogError]
    @ErrorLogID INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return if there is no error information to log
    IF ERROR_NUMBER() IS NULL
        RETURN;
    
    -- Return if inside an uncommittable transaction
    IF XACT_STATE() = -1
    BEGIN
        PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' +
              'Rollback the transaction before executing uspLogError in order to successfully log error information.';
        RETURN;
    END
    
    -- Insert error information into ErrorLog
    INSERT INTO [dbo].[ErrorLog]
    (
        [UserName],
        [ErrorNumber],
        [ErrorSeverity],
        [ErrorState],
        [ErrorProcedure],
        [ErrorLine],
        [ErrorMessage],
        [ErrorDetails]
    )
    VALUES
    (
        CONVERT([sysname], ORIGINAL_LOGIN()),
        ERROR_NUMBER(),
        ERROR_SEVERITY(),
        ERROR_STATE(),
        ERROR_PROCEDURE(),
        ERROR_LINE(),
        ERROR_MESSAGE(),
        (SELECT * FROM (VALUES
            ('Number', ISNULL(CAST(ERROR_NUMBER() AS NVARCHAR(20)), 'NULL')),
            ('Severity', ISNULL(CAST(ERROR_SEVERITY() AS NVARCHAR(20)), 'NULL')),
            ('State', ISNULL(CAST(ERROR_STATE() AS NVARCHAR(20)), 'NULL')),
            ('Procedure', ISNULL(ERROR_PROCEDURE(), 'NULL')),
            ('Line', ISNULL(CAST(ERROR_LINE() AS NVARCHAR(20)), 'NULL')),
            ('Message', ISNULL(ERROR_MESSAGE(), 'NULL'))
        ) AS ErrorData([Property], [Value])
        FOR JSON PATH)
    );
    
    -- Return the ErrorLogID of the row inserted
    SET @ErrorLogID = SCOPE_IDENTITY();
    
    RETURN @ErrorLogID;
END;
GO

PRINT 'Created uspLogError stored procedure';
GO

-- Create a wrapper procedure to execute scripts with error handling
IF OBJECT_ID('dbo.sp_ExecuteSQLScript', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_ExecuteSQLScript];
GO

CREATE PROCEDURE [dbo].[sp_ExecuteSQLScript]
    @SQL NVARCHAR(MAX),
    @PrintOnly BIT = 0,
    @Debug BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorLogID INT;
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @ErrorMessage NVARCHAR(4000);
    
    BEGIN TRY
        IF @PrintOnly = 1 OR @Debug = 1
            PRINT '-- Executing SQL Script --';
            
        IF @PrintOnly = 0
            EXEC sp_executesql @SQL;
        ELSE
            PRINT @SQL;
            
        IF @Debug = 1
            PRINT '-- Execution completed successfully --';
            
        RETURN 0; -- Success
    END TRY
    BEGIN CATCH
        -- Log the error
        EXEC [dbo].[uspLogError] @ErrorLogID = @ErrorLogID OUTPUT;
        
        -- Get error information
        SELECT 
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorMessage = ERROR_MESSAGE();
            
        -- Print error information if in debug mode
        IF @Debug = 1
        BEGIN
            PRINT '-- Error occurred --';
            PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
            PRINT 'Error Message: ' + @ErrorMessage;
            PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS NVARCHAR(20));
            PRINT 'Error State: ' + CAST(@ErrorState AS NVARCHAR(20));
            PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'NULL');
            PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(20));
            PRINT 'Error Log ID: ' + ISNULL(CAST(@ErrorLogID AS NVARCHAR(20)), 'NULL');
        END
        
        RETURN -1; -- Failure
    END CATCH;
END;
GO

PRINT 'Created sp_ExecuteSQLScript stored procedure';
GO

-- Create a table to track database version and changes
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DatabaseVersion' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[DatabaseVersion]
    (
        [VersionID] [int] IDENTITY(1,1) NOT NULL,
        [VersionNumber] [nvarchar](50) NOT NULL,
        [AppliedDate] [datetime] NOT NULL DEFAULT (getdate()),
        [Description] [nvarchar](500) NULL,
        [ScriptName] [nvarchar](255) NULL,
        [Checksum] [varbinary](150) NULL,
        [AppliedBy] [nvarchar](128) NOT NULL DEFAULT (suser_sname()),
        [Success] [bit] NOT NULL DEFAULT (1),
        [ErrorMessage] [nvarchar](4000) NULL,
        [ExecutionTimeMs] [bigint] NULL,
        [IsRollback] [bit] NOT NULL DEFAULT (0),
        [RollbackScript] [nvarchar](max) NULL,
        CONSTRAINT [PK_DatabaseVersion] PRIMARY KEY CLUSTERED ([VersionID] ASC)
    );
    
    -- Insert initial version
    INSERT INTO [dbo].[DatabaseVersion] ([VersionNumber], [Description], [ScriptName])
    VALUES ('1.0.0', 'Initial database creation', '00_FullDatabaseRecreate.sql');
    
    PRINT 'Created DatabaseVersion table and inserted initial version';
END
GO

-- Create stored procedure to log database version changes
IF OBJECT_ID('dbo.usp_LogDatabaseVersion', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_LogDatabaseVersion];
GO

CREATE PROCEDURE [dbo].[usp_LogDatabaseVersion]
    @VersionNumber NVARCHAR(50),
    @Description NVARCHAR(500) = NULL,
    @ScriptName NVARCHAR(255) = NULL,
    @Checksum VARBINARY(150) = NULL,
    @Success BIT = 1,
    @ErrorMessage NVARCHAR(4000) = NULL,
    @ExecutionTimeMs BIGINT = NULL,
    @IsRollback BIT = 0,
    @RollbackScript NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[DatabaseVersion]
    (
        [VersionNumber],
        [Description],
        [ScriptName],
        [Checksum],
        [AppliedBy],
        [Success],
        [ErrorMessage],
        [ExecutionTimeMs],
        [IsRollback],
        [RollbackScript]
    )
    VALUES
    (
        @VersionNumber,
        @Description,
        @ScriptName,
        @Checksum,
        SUSER_SNAME(),
        @Success,
        @ErrorMessage,
        @ExecutionTimeMs,
        @IsRollback,
        @RollbackScript
    );
    
    RETURN SCOPE_IDENTITY();
END;
GO

PRINT 'Created usp_LogDatabaseVersion stored procedure';
GO

-- Log successful completion of initial database setup
DECLARE @StartTime DATETIME = GETDATE();
DECLARE @EndTime DATETIME = GETDATE();
DECLARE @ExecutionTimeMs BIGINT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

EXEC [dbo].[usp_LogDatabaseVersion]
    @VersionNumber = '1.0.0',
    @Description = 'Initial database setup completed successfully',
    @ScriptName = '00_FullDatabaseRecreate.sql',
    @Success = 1,
    @ExecutionTimeMs = @ExecutionTimeMs;

PRINT '================================================================';
PRINT 'Oven Delights ERP Database Setup - Initial Phase Complete';
PRINT 'Database: Oven_Delights_Main';
PRINT 'Created on: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT 'Next steps: Run the table creation scripts in order.';
PRINT '================================================================';
GO
